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
        self.objects = [
            self.menuCellForIsland(island: .centralCheungChau)
        ]
        self.collectionView.reloadData()
    }

    func menuCellForIsland(island: Island) -> MenuCell {
        let raws = ModelManager.shared.getRaws()
        let schedule = Schedule(raws: raws)

        let fromFerries = schedule.upcomingFerries(island: island, direction: .fromPrimary, count: 2)
        let toFerries = schedule.upcomingFerries(island: island, direction: .toPrimary, count: 2)
        let df = DateFormatter()
        df.dateStyle = .none
        df.timeStyle = .short

        // TODO
        var primaryLocation = island.rawValue
        var secondaryLocation = ""

        var fromPrimary1 = ""
        var fromPrimarySub1 = ""
        var fromPrimary2 = ""
        var fromPrimarySub2 = ""

        var toPrimary1 = ""
        var toPrimarySub1 = ""
        var toPrimary2 = ""
        var toPrimarySub2 = ""

        if fromFerries.count >= 1 {
            fromPrimary1 = df.string(from: fromFerries[0].time)
            fromPrimarySub1 = "3 mins left"
        }
        if fromFerries.count >= 2 {
            fromPrimary2 = df.string(from: fromFerries[1].time)
            fromPrimarySub2 = "3 mins left"
        }
        if toFerries.count >= 1 {
            toPrimary1 = df.string(from: toFerries[0].time)
            toPrimarySub1 = "3 mins left"
        }
        if toFerries.count >= 2 {
            toPrimary2 = df.string(from: toFerries[1].time)
            toPrimarySub2 = "3 mins left"
        }

        return MenuCell(
            primaryLocation: primaryLocation,
            secondaryLocation: secondaryLocation,
            fromPrimary1: fromPrimary1,
            fromPrimarySub1: fromPrimarySub1,
            fromPrimary2: fromPrimary2,
            fromPrimarySub2: fromPrimarySub2,
            toPrimary1: toPrimary1,
            toPrimarySub1: toPrimarySub1,
            toPrimary2: toPrimary2,
            toPrimarySub2: toPrimarySub2
        )
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

