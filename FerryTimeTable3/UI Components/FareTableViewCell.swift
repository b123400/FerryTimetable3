//
//  FareTableViewCell.swift
//  FerryTimetable3
//
//  Created by b123400 on 2020/11/23.
//  Copyright © 2020 b123400. All rights reserved.
//

import UIKit

class FareTableViewCell: UITableViewCell {
    
    lazy var multipleLineTextLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 10
        return l
    }()
    
    lazy var subLabel: UILabel = {
        let l = UILabel()
        l.textColor = UIColor.secondaryLabel
        l.textAlignment = .right
        l.setContentCompressionResistancePriority(.required, for: .horizontal)
        return l
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(self.multipleLineTextLabel)
        self.contentView.addSubview(self.subLabel)
        
        self.multipleLineTextLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(12)
        }
        self.subLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(12)
            make.left.equalTo(self.multipleLineTextLabel.snp.right).offset(16)
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
