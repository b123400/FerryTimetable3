//
//  ResidenceTableViewCell.swift
//  FerryTimetable3
//
//  Created by b123400 on 2021/05/30.
//  Copyright © 2021 b123400. All rights reserved.
//

import UIKit

class ResidenceTableViewCell: UITableViewCell {
    let scheduleView: ResidenceSchedulesView
    let loading: UIActivityIndicatorView

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        scheduleView = ResidenceSchedulesView()
        loading = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        loading.hidesWhenStopped = true
        loading.startAnimating()

        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(scheduleView)
        self.contentView.addSubview(loading)
        
        scheduleView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(10)
        }
        loading.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        let v = UIView()
        v.layer.borderWidth = 3
        v.layer.borderColor = UIColor.systemBlue.cgColor
        v.layer.cornerRadius = 10
        self.selectedBackgroundView = v
    }

    func apply(model: ResidenceSchedulesView.Model) {
        scheduleView.apply(model: model)
        loading.stopAnimating()
    }
}
