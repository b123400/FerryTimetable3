//
//  FerryTypeTableViewCell.swift
//  FerryTimetable3
//
//  Created by b123400 on 2020/10/18.
//  Copyright © 2020 b123400. All rights reserved.
//

import UIKit
import SnapKit

class FerryTypeTableViewCell: UITableViewCell {
    
    var label: UILabel = {
        let l = UILabel()
        l.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
        return l
    }()
    
    var colorView: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 2.5
        return v
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(label)
        self.contentView.addSubview(colorView)
        
        colorView.snp.makeConstraints { (make) in
            make.width.equalTo(5)
            make.top.bottom.equalToSuperview().inset(8)
            make.left.equalToSuperview().offset(20)
        }
        
        label.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(8)
            make.left.equalTo(colorView.snp.right).offset(8)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
