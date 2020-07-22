//
//  TimetableViewController.swift
//  FerryTimetable3
//
//  Created by b123400 on 2020/07/22.
//  Copyright © 2020 b123400. All rights reserved.
//

import UIKit

class FerriesViewController<T: RenderTime>: UITableViewController {
    var ferries: [Ferry<T>] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(FerriesTableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.separatorStyle = .none
        self.tableView.rowHeight = UITableView.automaticDimension

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ferries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        if let c = cell as? FerriesTableViewCell {
            let ferry = ferries[indexPath.row]
            c.apply(model: FerryCell(ferry: ferry))
        }

        return cell
    }
}
