//
//  FerryDatePickerViewController.swift
//  FerryTimetable3
//
//  Created by b123400 on 2020/07/23.
//  Copyright © 2020 b123400. All rights reserved.
//

import UIKit
import PDTSimpleCalendar

protocol FerryDatePickerViewControllerDelegate {
    func didSelect(date: Date)
    func didSelectNow()
}

class FerryDatePickerViewController: PDTSimpleCalendarViewController, PDTSimpleCalendarViewDelegate {
    var calendarDelegate: FerryDatePickerViewControllerDelegate?
    lazy var holidayDates: [Date] = {
        ModelManager.shared.holidays.map { $0.day.midnight }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.delegate = self
        
        self.view.backgroundColor = .systemBackground
        self.collectionView.backgroundColor = .systemBackground
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Cancel",comment:""), style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelButtonTapped(sender:)))
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(close))
        navigationItem.rightBarButtonItem = closeButton

        let todayButton = UIBarButtonItem(title: NSLocalizedString("Now", comment: ""),
                                          style: .plain,
                                          target: self,
                                          action: #selector(nowTapped))
        navigationItem.leftBarButtonItem = todayButton
    }
    
    @objc func cancelButtonTapped(sender:UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    @objc func close() {
        dismiss(animated: true, completion: nil)
    }

    @objc func nowTapped() {
        dismiss(animated: true, completion: nil)
        self.calendarDelegate?.didSelectNow()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath)
        if let c = cell as? PDTSimpleCalendarViewCell {
            c.circleDefaultColor = .clear
            c.refreshCellColors()
        }
        return cell
    }
    
    func simpleCalendarViewController(_ controller: PDTSimpleCalendarViewController!, didSelect date: Date!) {
        self.dismiss(animated: true, completion: nil)
        self.calendarDelegate?.didSelect(date: date)
    }
    
    func simpleCalendarViewController(_ controller: PDTSimpleCalendarViewController!, circleColorFor date: Date!) -> UIColor! {
        let dayStart = midnight(date: date)
        let isHoliday = self.holidayDates.contains(dayStart)
        if isHoliday {
            return UIColor.systemRed
        }
        return UIColor.secondarySystemBackground
    }
    
    func simpleCalendarViewController(_ controller: PDTSimpleCalendarViewController!, shouldUseCustomColorsFor date: Date!) -> Bool {
        return true
    }
    
    func simpleCalendarViewController(_ controller: PDTSimpleCalendarViewController!, textColorFor date: Date!) -> UIColor! {
        let dayStart = midnight(date: date)
        let isHoliday = self.holidayDates.contains(dayStart)
        if isHoliday {
            return .white
        }
        return .label
    }
}
