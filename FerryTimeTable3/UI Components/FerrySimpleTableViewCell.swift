//
//  FerryTypeTableViewCell.swift
//  FerryTimetable3
//
//  Created by b123400 on 2020/10/17.
//  Copyright © 2020 b123400. All rights reserved.
//

import UIKit

class FerrySimpleTableViewCell: UITableViewCell {
    var label: UILabel = {
        let l = UILabel()
        return l
    }()
    
    var colorView: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 2.5
        return v
    }()
    
    var canSelect = false

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(label)
        self.contentView.addSubview(colorView)
        
        colorView.snp.makeConstraints { (make) in
            make.width.equalTo(5)
            make.top.bottom.equalToSuperview().inset(0)
            make.left.equalToSuperview().offset(0)
        }
        
        label.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(8)
            make.left.equalTo(colorView.snp.right).offset(8)
        }
        
        let v = UIView()
        v.backgroundColor = .secondarySystemFill
        self.selectedBackgroundView = v
    }
    
    func apply(model: MenuCell) {
        label.text = model.primaryLocation + " ↔︎ " + model.secondaryLocation
        colorView.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
