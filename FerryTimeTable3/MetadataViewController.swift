//
//  MetadataViewController.swift
//  FerryTimetable3
//
//  Created by b123400 on 2020/11/23.
//  Copyright © 2020 b123400. All rights reserved.
//

import UIKit

class MetadataViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var ferry: Ferry<Date>? = nil
    private var island: Island? = nil
    private var metadata: Metadata? = nil
    
    enum Sections {
        case durations
        case arrival
        case fare
    }
    private var sections: [Sections] = []
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(close))
        navigationItem.rightBarButtonItem = closeButton
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
    
    lazy var tableView: UITableView = {
        let v = UITableView(frame: .zero, style: .insetGrouped)
        v.delegate = self
        v.dataSource = self
        v.register(FareTableViewCell.self, forCellReuseIdentifier: "fare")
        v.rowHeight = UITableView.automaticDimension
        v.estimatedRowHeight = 44.0
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    public func updateFerry(ferry: Ferry<Date>, island: Island) {
        self.ferry = ferry
        self.island = island
        configureView()
    }
    
    func configureView() {
        let ms = ModelManager.shared.getMetadatas()
        if let i = island,
           let m = ms[i],
           let f = ferry {
            let m = filterMetadata(metadata: m, ferry: f)
            self.metadata = m
            self.sections = []
            if m.durations.count > 0 {
                self.sections.append(.durations)
                self.sections.append(.arrival)
            }
            if m.fares.count > 0 {
                self.sections.append(.fare)
            }
        } else {
            self.metadata = nil
            self.sections = []
        }
        self.tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let s = sections[section]
        switch s {
        case .durations:
            return metadata?.durations.count ?? 0
        case .arrival:
            return 1;
        case .fare:
            return metadata?.fares.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        if let m = metadata {
            switch section {
            case .durations:
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
                let c = cell ??
                    UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "cell")
                
                let duration = m.durations[indexPath.row]
                c.textLabel?.text = NSLocalizedString("Duration", comment: "")
                let durationInt = Int(duration.duration / 60.0)
                c.detailTextLabel?.text = String(format: NSLocalizedString("%d min", comment: ""), durationInt)
                return c
            case .arrival:
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
                let c = cell ??
                    UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "cell")
                let duration = m.durations.first!
                let date = self.ferry?.time.advanced(by: duration.duration)
                c.textLabel?.text = NSLocalizedString("Arrival", comment: "")
                if let d = date {
                    let formatter = DateFormatter()
                    formatter.timeStyle = .short
                    formatter.dateStyle = .short
                    c.detailTextLabel?.text = formatter.string(from: d)
                } else {
                    c.detailTextLabel?.text = ""
                }
                return c
            case .fare:
                let cell = tableView.dequeueReusableCell(withIdentifier: "fare", for: indexPath) as! FareTableViewCell
                let fare = m.fares[indexPath.row]
                let passengerString = NSMutableAttributedString(string: fare.passenger)
                if fare.type == .slowFerryDeluxeClass {
                    let str = NSAttributedString(string: NSLocalizedString("Deluxe", comment: ""),
                                                 attributes: [.backgroundColor : UIColor.systemBlue,
                                                              .foregroundColor: UIColor.white
                                                 ])
                    passengerString.append(NSAttributedString(string: " "))
                    passengerString.append(str)
                }
                cell.multipleLineTextLabel.attributedText = passengerString
                cell.subLabel.text = String(format: "$%.1f", fare.fare)
                return cell
            }
        }
        return UITableViewCell()
    }
}
