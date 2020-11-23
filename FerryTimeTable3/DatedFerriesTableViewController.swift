//
//  DatedFerriesTableViewController.swift
//  FerryTimetable3
//
//  Created by b123400 on 2020/07/22.
//  Copyright © 2020 b123400. All rights reserved.
//

import UIKit

protocol DatedFerriesTableViewControllerDelegate {
    func shouldShowTypeHintFor(ferries: [Ferry<Date>]) -> Bool
}

class DatedFerriesTableViewController: FerriesViewController<Date> {
    let direction: Direction
    let island: Island
    var delegate: DatedFerriesTableViewControllerDelegate?
    
    // No date = now, date = the "day", not related to time
    var date: Date? {
        didSet {
            configureFerries()
        }
    }
    
    init(
        style: UITableView.Style,
        direction: Direction,
        island: Island
    ) {
        self.direction = direction
        self.island = island
        super.init(style: style)
        configureFerries()
        
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] (timer) in
            self?.configureFerries()
        }
        reloadTypeHints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureFerries() {
        let schedule = Schedule(raws: ModelManager.shared.getRaws())
        let count = 50
        let ferries: [Ferry<Date>]
        if let d = date {
            ferries = schedule.upcomingFerries(date: midnight(date: d), island: island, direction: direction, count: count)
        } else {
            ferries = schedule.upcomingFerries(island: island, direction: direction, count: 20)
        }
        self.ferries = ferries
    }
    
    func reloadTypeHints() {
        if let d = self.delegate {
            super.showsTypeHint = d.shouldShowTypeHintFor(ferries: ferries)
        }
    }
    
    func loadMoreFerries() {
        let schedule = Schedule(raws: ModelManager.shared.getRaws())
        let count = 50
        let d = self.ferries.last.map { $0.time.addingTimeInterval(1) } ?? Date()
        let newFerries = schedule.upcomingFerries(date: d, island: island, direction: direction, count: count)
        self.ferries.append(contentsOf: newFerries)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if super.responds(to: Selector(("scrollViewDidScroll"))) {
            super.scrollViewDidScroll(scrollView)
        }
        if scrollView != self.tableView {
            return
        }
        let reachedBottom = scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height)
        if reachedBottom {
            loadMoreFerries()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ferry = self.ferries[indexPath.row]
        let vc = MetadataViewController()
        let metadata = ModelManager.shared.getMetadatas()[self.island]
        if metadata != nil {
            vc.updateFerry(ferry: ferry, island: self.island)
            let nav = UINavigationController(rootViewController: vc)
            present(nav, animated: true, completion: nil)
        }
    }
}
