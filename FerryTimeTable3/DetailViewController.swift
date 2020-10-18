//
//  DetailViewController.swift
//  FerryTimetable3
//
//  Created by b123400 on 2020/06/30.
//  Copyright © 2020 b123400. All rights reserved.
//

import UIKit
import PDTSimpleCalendar

class DetailViewController:
    UIViewController,
    UIScrollViewDelegate,
    FerryDatePickerViewControllerDelegate,
    DatedFerriesTableViewControllerDelegate,
    UIPopoverPresentationControllerDelegate {
    
    var island: Island? {
        didSet {
            configureView()
        }
    }
    
    var fromVC: DatedFerriesTableViewController?
    var toVC: DatedFerriesTableViewController?
    
    lazy var titleView = DirectionSwitchingView()
    
    lazy var scrollView: UIScrollView = {
        let v = UIScrollView()
        v.isPagingEnabled = true
        v.showsHorizontalScrollIndicator = false
        v.clipsToBounds = false
        v.delegate = self
        return v
    }()

    func configureView() {
        self.title = ""
        titleView.island = island
        
        for child in Array(self.children) {
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
        
        if let i = island {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            
            let fromVC = DatedFerriesTableViewController(style: .plain, direction: .fromPrimary, island: i)
            stackView.addArrangedSubview(fromVC.view)
            self.addChild(fromVC)
            
            let toVC = DatedFerriesTableViewController(style: .plain, direction: .toPrimary, island: i)
            stackView.addArrangedSubview(toVC.view)
            self.addChild(toVC)
            
            self.scrollView.addSubview(stackView)
            
            stackView.snp.makeConstraints { (make) in
                make.edges.equalTo(self.scrollView)
            }
            fromVC.view.snp.makeConstraints { (make) in
                make.width.equalTo(self.scrollView.snp.width)
                make.height.equalTo(400)
            }
            toVC.view.snp.makeConstraints { (make) in
                make.width.equalTo(self.scrollView.snp.width)
                make.height.equalTo(400)
            }
            self.fromVC = fromVC
            self.toVC = toVC
            self.fromVC?.delegate = self
            self.toVC?.delegate = self

            updateChildrenShowsTypeHint()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.largeTitleDisplayMode = .never
        let a = UINavigationBarAppearance()
        a.configureWithTransparentBackground()
        self.navigationItem.standardAppearance = a
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "calendar"), style: .plain, target: self, action: #selector(showDatePicker))
        
        self.view.addSubview(titleView)
        self.view.addSubview(scrollView)
        
        titleView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(4)
            make.left.equalTo(self.view.safeAreaLayoutGuide).offset(20)
            make.right.equalToSuperview()
        }
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(titleView.snp.bottom)
            make.bottom.left.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.85)
        }
        
        configureView()
        
        NotificationCenter.default.addObserver(forName: .showsRichMenuUpdated, object: nil, queue: .main) { [weak self] (notification) in
            self?.updateChildrenShowsTypeHint()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let vc = fromVC {
            vc.view.snp.updateConstraints { (make) in
                make.height.equalTo(self.scrollView.frame.height - self.scrollView.adjustedContentInset.bottom - self.scrollView.adjustedContentInset.top)
            }
        }
        if let vc = toVC {
            vc.view.snp.updateConstraints { (make) in
                make.height.equalTo(self.scrollView.frame.height - self.scrollView.adjustedContentInset.bottom - self.scrollView.adjustedContentInset.top)
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = scrollView.contentOffset.x / (scrollView.contentSize.width - scrollView.frame.width)
        self.titleView.progress = index
    }
    
    @objc func showDatePicker() {
        let calendarViewController = FerryDatePickerViewController()
        calendarViewController.calendarDelegate = self
        
        let nav = UINavigationController(rootViewController: calendarViewController)
        nav.modalPresentationStyle = .popover
        let popPC = nav.popoverPresentationController
        if popPC == nil {
            return
        }
        popPC!.barButtonItem = self.navigationItem.rightBarButtonItem
        popPC!.permittedArrowDirections = .any
        popPC!.delegate = self
        present(nav, animated: true, completion: nil)
    }
    
    func updateChildrenShowsTypeHint() {
        self.fromVC?.reloadTypeHints()
        self.toVC?.reloadTypeHints()
    }
    
    func shouldShowTypeHintFor(ferries: [Ferry<Date>]) -> Bool {
        let routeHasSpeedDifference = ferries.first?.modifiers.contains { [.fastFerry, .slowFerry, .optionalFerry].contains($0) } ?? false
        if !routeHasSpeedDifference {
            return false
        }
        /* Not sure why but we need this to detect the display type correctly */
        let _ = self.splitViewController?.view.frame.size.width
        let _ = self.view.frame.size.width
        //////
        
        if self.splitViewController?.displayMode == .some(.allVisible) || !(self.splitViewController?.isCollapsed ?? false) {
            return !ModelManager.shared.showsRichMenu
        } else {
            return true
        }
    }
    
    func didSelect(date: Date) {
        self.fromVC?.date = date;
        self.fromVC?.date = date;
    }
    func didSelectNow() {
        self.fromVC?.date = Date();
        self.fromVC?.date = Date();
    }
}

