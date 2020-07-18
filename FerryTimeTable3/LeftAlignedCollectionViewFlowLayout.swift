//
//  LeftAlignedCollectionViewFlowLayout.swift
//  FerryTimeTable3
//
//  Created by b123400 on 2020/07/02.
//  Copyright © 2020 b123400. All rights reserved.
//

import UIKit

class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)

        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        return attributes?.map { la in
            let layoutAttribute = la.copy() as! UICollectionViewLayoutAttributes
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }

            layoutAttribute.frame.origin.x = leftMargin

            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
            return layoutAttribute
        }
    }
}
