//
//  DetailViewController.swift
//  FerryTimetable3
//
//  Created by b123400 on 2020/06/30.
//  Copyright © 2020 b123400. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var island: Island? {
        didSet {
            configureView()
        }
    }
    
    var fromVC: UIViewController?
    var toVC: UIViewController?
    
    lazy var scrollView: UIScrollView = {
        let v = UIScrollView()
        v.isPagingEnabled = true
        return v
    }()

    func configureView() {
        if let i = island {
            self.title = i.primaryName + " ↔︎ " + i.secondaryName
        }
        
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
                make.width.equalTo(self.scrollView.snp.width).multipliedBy(0.8)
                make.height.equalTo(400)
            }
            toVC.view.snp.makeConstraints { (make) in
                make.width.equalTo(self.scrollView.snp.width).multipliedBy(0.8)
                make.height.equalTo(400)
            }
            self.fromVC = fromVC
            self.toVC = toVC
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
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
}

