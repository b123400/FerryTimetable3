//
//  MasterViewController.swift
//  FerryTimetable3
//
//  Created by b123400 on 2020/06/30.
//  Copyright © 2020 b123400. All rights reserved.
//

import UIKit
import Combine
import CoreLocation

class MasterViewController: UITableViewController, CLLocationManagerDelegate {
    var objects = [MenuCell]()
    var residenceModel: ResidenceSchedulesView.Model? = nil
    lazy var locationManager: CLLocationManager = {
        let m = CLLocationManager()
        m.delegate = self
        return m
    }()
    var location: CLLocation? = nil {
        didSet {
            self.prepareObjects()
            
            if ModelManager.shared.autoShowResidence && oldValue == nil,
               let model = self.residenceModel,
               let detailNav = (self.splitViewController?.viewControllers.count ?? 0) > 1
                ? (self.splitViewController?.viewControllers[1] as? UINavigationController)
                : (self.navigationController?.topViewController as? UINavigationController),
               let detail = detailNav.topViewController as? DetailViewController {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    detail.initialDirection = model.direction
                    detail.scrollToDirection(direction: model.direction)
                }
            }
        }
    }

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
        self.tableView.register(ResidenceTableViewCell.self, forCellReuseIdentifier: "residence-cell")

        let settingsButton = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .plain, target: self, action: #selector(openSettings))
        navigationItem.leftBarButtonItem = settingsButton
        setupRightBarButtonItem()

        Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] (timer) in
            self?.prepareObjects()
        }
        ModelManager.shared.objectWillChange.receive(subscriber: Subscribers.Sink(receiveCompletion: { _ in
            
        }, receiveValue: { [weak self] _ in
            DispatchQueue.main.async {
                self?.prepareObjects()
                if ModelManager.shared.residentModeReady && self?.location == nil {
                    _ = self?.tryFetchUserLocation()
                }
            }
        }))
        prepareObjects()
        
        if ModelManager.shared.residentModeReady && (!(self.splitViewController?.isCollapsed ?? true) || ModelManager.shared.autoShowResidence) {
            if let r = ModelManager.shared.selectedResidence {
                showIsland(island: r.island)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _ = tryFetchUserLocation()
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
            let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                if indexPath.section == 1,
                   let i = ModelManager.shared.selectedResidence?.island {
                    controller.island = i
                    if let m = self.residenceModel {
                        controller.initialDirection = m.direction
                    }
                } else {
                    let i = ModelManager.shared.islands[indexPath.row]
                    controller.island = i
                }
            }
        }
    }

    func prepareObjects() {
        self.objects = ModelManager.shared.islands.map(self.menuCellForIsland)
        if let l = location,
           let island = ModelManager.shared.selectedResidence?.island,
           let d = ModelManager.shared.residenceDirectionWith(location: l) {
            let raws = ModelManager.shared.getRaws()
            let schedule = Schedule(raws: raws)
            let ferries = schedule.upcomingFerries(island: island, direction: d, count: 4)
            residenceModel = ResidenceSchedulesView.Model(
                        island: island,
                        direction: d,
                        ferries: ferries
            )
        } else {
            residenceModel = nil
        }
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
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "residence-cell", for: indexPath)
            if let c = cell as? ResidenceTableViewCell {
                if let model = residenceModel {
                    c.apply(model: model)
                }
                return c
            }
        }

        let rowModel = self.objects[indexPath.row]
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
        if indexPath.section == 1 {
            return 220
        }
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 && ModelManager.shared.residentModeReady {
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
            let indexPath =
                ModelManager.shared.residentModeReady && ModelManager.shared.selectedResidence?.island == island
                ? IndexPath(row: 0, section: 1)
                : IndexPath(row: index, section: 2)
            self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .middle)
            self.tableView(self.tableView, didSelectRowAt: indexPath)
        }
    }
    
    func tryFetchUserLocation() -> Bool {
        if ModelManager.shared.residentModeReady {
            locationManager.requestLocation()
            return true
        }
        return false
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = locations.first
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Cannot get location \(error)")
    }
}

