//
//  MasterViewController.swift
//  FerryTimetable3
//
//  Created by b123400 on 2020/06/30.
//  Copyright © 2020 b123400. All rights reserved.
//

import UIKit
import SwiftUI

class MasterViewController: UICollectionViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [MenuCell]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        navigationItem.leftBarButtonItem = editButtonItem

        self.title = "HK Ferries"
        self.navigationController?.navigationBar.prefersLargeTitles = true

        if let layout = self.collectionViewLayout as? LeftAlignedCollectionViewFlowLayout {
            layout.itemSize = CGSize(width: 296, height: 200)
            layout.sectionInset.left = 12
            layout.minimumInteritemSpacing = 30
        }

//        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
//        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        prepareObjects()
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    @objc
    func insertNewObject(_ sender: Any) {
//        objects.insert(NSDate(), at: 0)
//        let indexPath = IndexPath(row: 0, section: 0)
//        tableView.insertRows(at: [indexPath], with: .automatic)
    }
//
//    // MARK: - Segues
//
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
//            if let indexPath = tableView.indexPathForSelectedRow {
//                let object = objects[indexPath.row] as! NSDate
//                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
//                controller.detailItem = object
//                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
//                controller.navigationItem.leftItemsSupplementBackButton = true
//                detailViewController = controller
//            }
        }
    }

    func prepareObjects() {
        self.objects = Island.allCases.map(self.menuCellForIsland)
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
}

