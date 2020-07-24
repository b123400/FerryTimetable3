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
            reloadSections()
        }
    }
    
    // Splitted into spections by date
    var sectionedFerries: [[Ferry<T>]] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(FerriesTableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.separatorStyle = .none
        self.tableView.rowHeight = UITableView.automaticDimension
    }
    
    func reloadSections() {
        if let f = ferries as? [Ferry<Date>] {
            sectionedFerries = splitByDate(ferries: f) as! [[Ferry<T>]]
        } else {
            sectionedFerries = [ferries]
        }
    }
    
    func splitByDate(ferries: [Ferry<Date>]) -> [[Ferry<Date>]] {
        var sections: [[Ferry<Date>]] = []
        for ferry in ferries {
            let lasts = sections.last
            let last: Ferry<Date>? = lasts?.last
            if let l = last, var ls = lasts {
                let day = midnight(date: ferry.time)
                let lastDay = midnight(date: l.time)
                if lastDay != day {
                    sections.append([ferry])
                } else {
                    ls.append(ferry)
                    sections[sections.count - 1] = ls
                }
            } else {
                sections.append([ferry])
            }
        }
        return sections
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionedFerries.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sectionedFerries[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        if let c = cell as? FerriesTableViewCell {
            let ferry = sectionedFerries[indexPath.section][indexPath.row]
            c.apply(model: FerryCell(ferry: ferry))
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let ferry = sectionedFerries[section].first as? Ferry<Date> {
            if midnight(date: ferry.time) == midnight(date: Date()) {
                return nil
            }
            let df = DateFormatter()
            df.timeStyle = .none
            df.dateStyle = .short
            df.timeZone = TimeZone(identifier: "Asia/Hong_Kong")!
            return df.string(from: ferry.time)
        } else {
            return nil
        }
    }
}
