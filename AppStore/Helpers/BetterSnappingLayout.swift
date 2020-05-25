//
//  BetterSnappingLayout.swift
//  AppStore
//
//  Created by Min on 2020/5/25.
//  Copyright © 2020 Min. All rights reserved.
//

import UIKit

class BetterSnappingLayout: UICollectionViewFlowLayout {

  override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
    guard let collectionView = collectionView else {
      return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
    }

    let nextX: CGFloat

    if proposedContentOffset.x <= 0 || collectionView.contentOffset == proposedContentOffset {
      nextX = proposedContentOffset.x
    } else {
      nextX = collectionView.contentOffset.x + (velocity.x > 0 ? collectionView.bounds.size.width : -collectionView.bounds.size.width)  // 拿到下一頁的X位置
    }

    let targetRect = CGRect(origin: CGPoint(x: nextX, y: 0), size: collectionView.bounds.size)

    var offsetAdjustment = CGFloat.greatestFiniteMagnitude

    let horizontalOffset = proposedContentOffset.x + collectionView.contentInset.left

    let layoutAttributesArray = super.layoutAttributesForElements(in: targetRect)

    layoutAttributesArray?.forEach({ (layoutAttrubutes) in
      let itemOffset = layoutAttrubutes.frame.origin.x
      if abs(Float(itemOffset - horizontalOffset)) < abs(Float(offsetAdjustment)) {
        offsetAdjustment = itemOffset - horizontalOffset
      }
    })

    return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
  }
}
