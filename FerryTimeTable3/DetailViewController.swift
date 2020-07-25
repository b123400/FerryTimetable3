//
//  DetailViewController.swift
//  FerryTimetable3
//
//  Created by b123400 on 2020/06/30.
//  Copyright © 2020 b123400. All rights reserved.
//

import UIKit
import BottomHalfModal

class DetailViewController: UIViewController, UIScrollViewDelegate {
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
        let vc = FerryDatePickerViewController()
        vc.callback = { [weak self] date in
            self?.fromVC?.date = date
            self?.toVC?.date = date
        }
        if UIDevice.current.userInterfaceIdiom == .pad {
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .popover
            nav.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
            self.present(nav, animated: true, completion: nil)
        } else {
            let nav = BottomHalfModalNavigationController(rootViewController: vc)
            presentBottomHalfModal(nav, animated: true, completion: nil)
        }
    }
}

