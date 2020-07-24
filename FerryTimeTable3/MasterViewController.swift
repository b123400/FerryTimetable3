//
//  MasterViewController.swift
//  FerryTimetable3
//
//  Created by b123400 on 2020/06/30.
//  Copyright © 2020 b123400. All rights reserved.
//

import UIKit

class MasterViewController: UICollectionViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [MenuCell]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "HK Ferries"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always

        self.collectionView.register(MenuCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        let settingsButton = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .plain, target: self, action: #selector(openSettings))
        navigationItem.rightBarButtonItem = settingsButton
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] (timer) in
            self?.prepareObjects()
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name.islandsUpdated,
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
    
    @objc func openSettings() {
        let vc = SettingsViewController()
        let nav = UINavigationController(rootViewController: vc)
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
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.objects.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        if let c = cell as? MenuCollectionViewCell {
            c.apply(model: self.objects[indexPath.row])
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showDetail", sender: self)
    }
}

