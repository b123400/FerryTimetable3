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
    
    var showsTypeHint = true {
        didSet {
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(FerriesTableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.register(FerryTypeTableViewCell.self, forCellReuseIdentifier: "type-cell")
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
        if self.showsTypeHint {
            return sectionedFerries.count + 1
        }
        return sectionedFerries.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.showsTypeHint {
            if section == 0 {
                return 3
            }
            return sectionedFerries[section - 1].count
        }
        return sectionedFerries[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let ferrySection = self.showsTypeHint ? indexPath.section - 1 : indexPath.section
        if indexPath.section == 0 && showsTypeHint {
            let cell = tableView.dequeueReusableCell(withIdentifier: "type-cell", for: indexPath)
            if let c = cell as? FerryTypeTableViewCell {
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let c = cell as? FerriesTableViewCell {
            let ferry = sectionedFerries[ferrySection][row]
            c.apply(model: FerryCell(ferry: ferry))
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let ferrySection = self.showsTypeHint ? section - 1 : section
        if section == 0 && showsTypeHint {
            return nil
        }
        if let ferry = sectionedFerries[ferrySection].first as? Ferry<Date> {
            if midnight(date: ferry.time) == midnight(date: Date()) {
                return NSLocalizedString("Today", comment: "")
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
