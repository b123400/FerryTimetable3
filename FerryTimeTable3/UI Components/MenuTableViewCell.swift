//
//  MenuCollectionViewCell.swift
//  FerryTimetable3
//
//  Created by b123400 on 2020/06/30.
//  Copyright © 2020 b123400. All rights reserved.
//

import UIKit
import SnapKit

class MenuTableViewCell: UITableViewCell {
    let scheduleView: CurrentScheduleView

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        scheduleView = CurrentScheduleView()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(scheduleView)
        
        scheduleView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(10)
        }
        let v = UIView()
        v.layer.borderWidth = 3
        v.layer.borderColor = UIColor.systemBlue.cgColor
        v.layer.cornerRadius = 10
        self.selectedBackgroundView = v
    }

    func apply(model: MenuCell) {
        scheduleView.apply(model: model)
    }
}
