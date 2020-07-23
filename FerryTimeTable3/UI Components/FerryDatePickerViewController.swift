//
//  FerryDatePickerViewController.swift
//  FerryTimetable3
//
//  Created by b123400 on 2020/07/23.
//  Copyright © 2020 b123400. All rights reserved.
//

import UIKit
import SnapKit
import BottomHalfModal

class FerryDatePickerViewController: UIViewController, SheetContentHeightModifiable {
    var sheetContentHeightToModify: CGFloat = 216

    let datePicker: UIDatePicker = {
        let v = UIDatePicker()
        v.datePickerMode = .date
        v.addTarget(self, action: #selector(dateUpdated), for: .valueChanged)
        return v
    }()
    
    var callback: ((Date?) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(close))
        navigationItem.rightBarButtonItem = closeButton
        
        let todayButton = UIBarButtonItem(title: NSLocalizedString("Now", comment: ""),
                                          style: .plain,
                                          target: self,
                                          action: #selector(todayTapped))
        navigationItem.leftBarButtonItem = todayButton

        self.view.addSubview(datePicker)
        
        datePicker.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let v = self.transitionCoordinator?.containerView {
            let tap = UITapGestureRecognizer()
            tap.addTarget(self, action: #selector(backdropTapped))
            v.addGestureRecognizer(tap)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        adjustFrameToSheetContentHeightIfNeeded()
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func todayTapped() {
        if let c = callback {
            c(nil)
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func backdropTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func dateUpdated() {
        if let c = callback {
            c(datePicker.date)
        }
    }
}
