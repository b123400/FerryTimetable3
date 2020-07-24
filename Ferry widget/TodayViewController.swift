//
//  TodayViewController.swift
//  Ferry widget
//
//  Created by b123400 on 2020/07/24.
//  Copyright © 2020 b123400. All rights reserved.
//

import UIKit
import NotificationCenter
import SnapKit

class TodayViewController: UIViewController, NCWidgetProviding {
    lazy var scheduleView = {
        WidgetView(frame: .zero)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        reload()
        self.view.addSubview(scheduleView)
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.scheduleView.translatesAutoresizingMaskIntoConstraints = false
        
        self.scheduleView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(openApp))
        self.scheduleView.addGestureRecognizer(tap)
        
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    }
    
    func reload() {
        let island = UserDefaults(suiteName: "group.net.b123400.ferriestimetable")?.string(forKey: "widget-island")
            .flatMap { Island.init(rawValue:$0) } ?? Island.centralCheungChau
        let schedule = Schedule(raws: ModelManager.shared.getRaws())
        let count = extensionContext?.widgetActiveDisplayMode == .some(.expanded) ? 2 : 1
        let fromFerries = schedule.upcomingFerries(island: island, direction: .fromPrimary, count: count)
        let toFerries = schedule.upcomingFerries(island: island, direction: .toPrimary, count: count)
        let model = MenuCell(island: island, fromFerries: fromFerries, toFerries: toFerries)
        scheduleView.apply(model: model)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        let expanded = activeDisplayMode == .expanded
        preferredContentSize = expanded ? CGSize(width: maxSize.width, height: 200) : maxSize
        reload()
    }
    
    @objc func openApp() {
        self.extensionContext?.open(URL(string: "ferriestimetable://widget")!, completionHandler: nil)
    }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
