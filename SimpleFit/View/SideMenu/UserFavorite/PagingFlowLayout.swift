//
//  PagingFlowLayout.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/3.
//

import UIKit

class PagingFlowLayout: UICollectionViewFlowLayout {

    private var pageSize: CGFloat { return itemSize.width + minimumLineSpacing }
    
    override func targetContentOffset(
        forProposedContentOffset proposedContentOffset: CGPoint,
        withScrollingVelocity velocity: CGPoint
    ) -> CGPoint {
        
        guard let collectionView = collectionView else { return proposedContentOffset }

        let offset = collectionView.contentOffset.x
        let velocity = velocity.x
        let flickVelocityThreshold: CGFloat = 0.2
        let currentPage = offset / pageSize

        if abs(velocity) > flickVelocityThreshold {
            let nextPage = velocity > 0.0 ? ceil(currentPage) : floor(currentPage)
            let nextPosition = nextPage * pageSize
            
            return CGPoint(x: nextPosition, y: proposedContentOffset.y)
        } else {
            let nextPosition = round(currentPage) * pageSize
            
            return CGPoint(x: nextPosition, y: proposedContentOffset.y)
        }
    }
}
