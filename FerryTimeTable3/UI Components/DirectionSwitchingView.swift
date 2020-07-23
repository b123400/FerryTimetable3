//
//  DirectionSwitchingView.swift
//  FerryTimetable3
//
//  Created by b123400 on 2020/07/23.
//  Copyright © 2020 b123400. All rights reserved.
//

import UIKit
import SnapKit

class DirectionSwitchingView: UIView {

    var island: Island? {
        didSet {
            reloadLabels()
        }
    }
    
    var progress: CGFloat = 0.0 {
        // 0 = fromPrimary, 1 = toPrimary
        didSet {
            rotateArrow()
        }
    }
    
    private let primaryLabel: UILabel = {
        let l = UILabel()
        return l
    }()
    
    private let arrowLabel: UILabel = {
        let l = UILabel()
        l.text = " → "
        return l
    }()
    
    private let secondaryLabel: UILabel = {
        let l = UILabel()
        return l
    }()
    
    private func reloadLabels() {
        primaryLabel.text = island?.primaryName
        secondaryLabel.text = island?.secondaryName
    }
    
    private func rotateArrow() {
        arrowLabel.layer.transform = CATransform3DMakeRotation(CGFloat.pi * progress, 0, 0, 1)
    }
    
    private func calculateFontSizeForWidth(_ width: CGFloat) -> CGFloat {
        let string = (island?.primaryName ?? "") + (arrowLabel.text ?? "") + (island?.secondaryName ?? "")
        var fontSize: CGFloat = 30
        while true {
            let size = string.size(withAttributes: [.font: UIFont.boldSystemFont(ofSize: fontSize)])
            if size.width > width - 20 {
                fontSize -= 0.5
            } else if fontSize <= 12 {
                return fontSize
            } else {
                return fontSize
            }
        }
    }
    
    init() {
        super.init(frame: CGRect.zero)
        self.addSubview(primaryLabel)
        self.addSubview(arrowLabel)
        self.addSubview(secondaryLabel)
        
        primaryLabel.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
        }
        arrowLabel.snp.makeConstraints { (make) in
            make.left.equalTo(primaryLabel.snp.right)
            make.top.bottom.equalToSuperview()
        }
        secondaryLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(arrowLabel.snp.right)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let fontSize = calculateFontSizeForWidth(self.frame.width)
        primaryLabel.font = UIFont.boldSystemFont(ofSize: fontSize)
        arrowLabel.font = UIFont.boldSystemFont(ofSize: fontSize)
        secondaryLabel.font = UIFont.boldSystemFont(ofSize: fontSize)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
