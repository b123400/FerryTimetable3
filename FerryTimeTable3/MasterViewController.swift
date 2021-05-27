//
//  MasterViewController.swift
//  FerryTimetable3
//
//  Created by b123400 on 2020/06/30.
//  Copyright © 2020 b123400. All rights reserved.
//

import UIKit
import Combine

class MasterViewController: UITableViewController {
    var objects = [MenuCell]()
    
    var showsTypeHint = true {
        didSet {
            self.tableView.reloadData()
            setupRightBarButtonItem()
        }
    }
    var needsToShowTypeHint: Bool {
        get {
            showsTypeHint && showsDetails
        }
    }
    var showsDetails = ModelManager.shared.showsRichMenu {
        didSet {
            self.tableView.reloadData()
            setupRightBarButtonItem()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("HK Ferries", comment: "")
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always

        self.tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.register(FerrySimpleTableViewCell.self, forCellReuseIdentifier: "simple-cell")

        let settingsButton = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .plain, target: self, action: #selector(openSettings))
        navigationItem.leftBarButtonItem = settingsButton
        setupRightBarButtonItem()

        Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] (timer) in
            self?.prepareObjects()
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name.islandsUpdated,
                                               object: nil,
                                               queue: OperationQueue.main) { [weak self] (_) in
                                                self?.prepareObjects()
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name.timetableUpdated,
                                               object: nil,
                                               queue: OperationQueue.main) { [weak self] (_) in
                                                self?.prepareObjects()
        }
        // TODO: make island update && timetable updated to use combine
        ModelManager.shared.objectWillChange.receive(subscriber: Subscribers.Sink(receiveCompletion: { _ in
            
        }, receiveValue: { [weak self] _ in
            self?.prepareObjects()
        }))
        prepareObjects()
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func setupRightBarButtonItem() {
        if showsDetails {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.bullet"),
                                                                     style: .plain,
                                                                     target: self,
                                                                     action: #selector(toggleShowsDetail))
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "rectangle.grid.1x2.fill"),
                                                                     style: .plain,
                                                                     target: self,
                                                                     action: #selector(toggleShowsDetail))
        }
    }
    
    @objc func toggleShowsDetail() {
        showsDetails = !showsDetails
        ModelManager.shared.showsRichMenu = showsDetails
    }
    
    @objc func openSettings() {
        let vc = SettingsViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .formSheet
        present(nav, animated: true, completion: nil)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let i = ModelManager.shared.islands[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.island = i
            }
        }
    }

    func prepareObjects() {
        self.objects = ModelManager.shared.islands.map(self.menuCellForIsland)
        self.tableView.reloadData()
    }

    func menuCellForIsland(island: Island) -> MenuCell {
        let raws = ModelManager.shared.getRaws()
        let schedule = Schedule(raws: raws)
        let fromFerries = schedule.upcomingFerries(island: island, direction: .fromPrimary, count: 2)
        let toFerries = schedule.upcomingFerries(island: island, direction: .toPrimary, count: 2)
        return MenuCell(island: island, fromFerries: fromFerries, toFerries: toFerries)
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            // type hints
            if self.needsToShowTypeHint {
                return 3
            }
            return 0
        }
        if section == 1 {
//            home route
            if ModelManager.shared.residentModeReady {
                return 1
            } else {
                return 0
            }
        }
        return self.objects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "simple-cell", for: indexPath)
            if let c = cell as? FerrySimpleTableViewCell {
                switch indexPath.row {
                case 0:
                    c.label.text = NSLocalizedString("Green for ordinary ferry", comment: "")
                    c.colorView.backgroundColor = .systemGreen
                    break;
                case 1:
                    c.label.text = NSLocalizedString("Red for fast ferry", comment: "")
                    c.colorView.backgroundColor = .systemRed
                    break;
                case 2:
                    c.label.text = NSLocalizedString("Yellow for optional ferry", comment: "")
                    c.colorView.backgroundColor = .systemYellow
                    break;
                default:
                    break;
                }
            }
            return cell
        }
        let rowModel: MenuCell
        if indexPath.section == 1 {
            rowModel = (ModelManager.shared.selectedResidence?.toIsland()).map { self.menuCellForIsland(island: $0) } ?? self.objects[0]
        } else {
            rowModel = self.objects[indexPath.row]
        }
        if !showsDetails {
            let cell = tableView.dequeueReusableCell(withIdentifier: "simple-cell", for: indexPath)
            if let c = cell as? FerrySimpleTableViewCell {
                c.apply(model: rowModel)
            }
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let c = cell as? MenuTableViewCell {
            c.apply(model: rowModel)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section != 0 && showsDetails {
            return 220
        }
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return NSLocalizedString("Home", comment: "")
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            return
        }
        self.performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if needsToShowTypeHint && indexPath.section == 0 {
            return false
        }
        return true
    }
    
    func showIsland(island: Island) {
        if let index = ModelManager.shared.islands.firstIndex(of: island) {
            let indexPath =  IndexPath(row: index, section: 2)
            self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .middle)
            self.tableView(self.tableView, didSelectRowAt: indexPath)
        }
    }
}

