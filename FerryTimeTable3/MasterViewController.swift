//
//  MasterViewController.swift
//  FerryTimetable3
//
//  Created by b123400 on 2020/06/30.
//  Copyright © 2020 b123400. All rights reserved.
//

import UIKit

class MasterViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var objects = [MenuCell]()
    
    var showsTypeHint = true {
        didSet {
            self.collectionView.reloadData()
            setupRightBarButtonItem()
        }
    }
    var needsToShowTypeHint: Bool {
        get {
            showsTypeHint && showsDetails
        }
    }
    var showsDetails = false {
        didSet {
            self.collectionView.reloadData()
            setupRightBarButtonItem()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("HK Ferries", comment: "")
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always

        self.collectionView.register(MenuCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        self.collectionView.register(FerrySimpleCollectionViewCell.self, forCellWithReuseIdentifier: "simple-cell")
        
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
        prepareObjects()
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let layout = self.collectionViewLayout as? LeftAlignedCollectionViewFlowLayout {
            layout.itemSize = CGSize(width: self.view.frame.width - 24, height: 200)
            layout.sectionInset.left = 12
            layout.minimumInteritemSpacing = 30
        }
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
            if let indexPath = collectionView.indexPathsForSelectedItems?.last {
                let i = ModelManager.shared.islands[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.island = i
            }
        }
    }

    func prepareObjects() {
        self.objects = ModelManager.shared.islands.map(self.menuCellForIsland)
        self.collectionView.reloadData()
    }

    func menuCellForIsland(island: Island) -> MenuCell {
        let raws = ModelManager.shared.getRaws()
        let schedule = Schedule(raws: raws)
        let fromFerries = schedule.upcomingFerries(island: island, direction: .fromPrimary, count: 2)
        let toFerries = schedule.upcomingFerries(island: island, direction: .toPrimary, count: 2)
        return MenuCell(island: island, fromFerries: fromFerries, toFerries: toFerries)
    }

    // MARK: - Table View

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            if self.needsToShowTypeHint {
                return 3
            }
            return 0
        }
        return self.objects.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "simple-cell", for: indexPath)
            if let c = cell as? FerrySimpleCollectionViewCell {
                switch indexPath.row {
                case 0:
                    c.label.text = NSLocalizedString("Green for ordinary ferry", comment: "")
                    c.colorView.backgroundColor = .systemGreen
                    break;
                case 1:
                    c.label.text = NSLocalizedString("Red for ordinary ferry", comment: "")
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
        if !showsDetails {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "simple-cell", for: indexPath)
            if let c = cell as? FerrySimpleCollectionViewCell {
                c.apply(model: self.objects[indexPath.row])
            }
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        if let c = cell as? MenuCollectionViewCell {
            c.apply(model: self.objects[indexPath.row])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (needsToShowTypeHint && indexPath.section == 0) || !showsDetails {
            return CGSize(width: self.view.frame.width - 24, height: 34)
        }
        return CGSize(width: self.view.frame.width - 24, height: 200)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            return
        }
        self.performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if needsToShowTypeHint && indexPath.section == 0 {
            return false
        }
        return true
    }
    
    func showIsland(island: Island) {
        if let index = ModelManager.shared.islands.firstIndex(of: island) {
            let indexPath =  IndexPath(row: index, section: 0)
            self.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredVertically)
            self.collectionView(self.collectionView, didSelectItemAt: indexPath)
        }
    }
}

