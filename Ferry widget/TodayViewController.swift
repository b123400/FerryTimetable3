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
import CoreLocation

class TodayViewController: UIViewController, NCWidgetProviding, CLLocationManagerDelegate {
    lazy var scheduleView = {
        WidgetView(frame: .zero)
    }()
    
    lazy var residentScheduleView = {
        WidgetResidenceSchedulesView(frame: .zero)
    }()
    var location: CLLocation? = nil {
        didSet {
            reload()
        }
    }
    lazy var locationManager: CLLocationManager = {
        let m = CLLocationManager()
        m.delegate = self
        return m
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        reload()
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        self.scheduleView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(openApp))
        self.scheduleView.addGestureRecognizer(tap)
        
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    }
    
    func reload() {
        let island = ModelManager.shared.homeRoute ?? .centralCheungChau
        let schedule = Schedule(raws: ModelManager.shared.getRaws())
        
        if ModelManager.shared.residentModeReady, let l = location, let direction = ModelManager.shared.residenceDirectionWith(location: l) {
            if residentScheduleView.superview == nil {
                self.view.addSubview(residentScheduleView)
                self.residentScheduleView.translatesAutoresizingMaskIntoConstraints = false
                self.scheduleView.removeFromSuperview()
            }
            let ferries = schedule.upcomingFerries(island: island, direction: direction, count: 4)
            residentScheduleView.apply(model: WidgetResidenceSchedulesView.Model(
                island: island,
                direction: direction,
                ferries: ferries
            ))
        } else {
            if scheduleView.superview == nil {
                self.view.addSubview(scheduleView)
                self.scheduleView.translatesAutoresizingMaskIntoConstraints = false
                self.residentScheduleView.removeFromSuperview()
            }
            let count = extensionContext?.widgetActiveDisplayMode == .some(.expanded) ? 2 : 1
            let fromFerries = schedule.upcomingFerries(island: island, direction: .fromPrimary, count: count)
            let toFerries = schedule.upcomingFerries(island: island, direction: .toPrimary, count: count)
            let model = MenuCell(island: island, fromFerries: fromFerries, toFerries: toFerries)
            scheduleView.apply(model: model)
        }
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        let expanded = activeDisplayMode == .expanded
        preferredContentSize = expanded ? CGSize(width: maxSize.width, height: 200) : maxSize
        reload()
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = locations.first
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Cannot get location \(error)")
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
