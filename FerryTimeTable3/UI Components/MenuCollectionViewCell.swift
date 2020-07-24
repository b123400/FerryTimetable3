//
//  MenuCollectionViewCell.swift
//  FerryTimetable3
//
//  Created by b123400 on 2020/06/30.
//  Copyright © 2020 b123400. All rights reserved.
//

import UIKit
import SnapKit

class MenuCollectionViewCell: UICollectionViewCell {
    let scheduleView: CurrentScheduleView

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        scheduleView = CurrentScheduleView(frame: frame)
        super.init(frame: frame)
        self.contentView.addSubview(scheduleView)
        
        scheduleView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    func apply(model: MenuCell) {
        scheduleView.apply(model: model)
    }
}
