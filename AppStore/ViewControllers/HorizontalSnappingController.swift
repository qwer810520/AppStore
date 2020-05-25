//
//  HorizontalSnappingController.swift
//  AppStore
//
//  Created by Min on 2020/5/25.
//  Copyright © 2020 Min. All rights reserved.
//

import UIKit

class HorizontalSnappingController: UICollectionViewController {

  // MARK: - Initialization

  init() {
    let layout = BetterSnappingLayout()
    layout.scrollDirection = .horizontal
    super.init(collectionViewLayout: layout)
    collectionView.decelerationRate = .fast
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class SnappingLayout: UICollectionViewFlowLayout {
  
  override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {

    guard let collectionView = self.collectionView else {
      return targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
    }

    let parent = super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)

    let itemWidth = collectionView.frame.width - 48
    let itemSpace = itemWidth + minimumInteritemSpacing
    var currentItemIndex = round(collectionView.contentOffset.x / itemSpace)

    let vX = velocity.x

    if vX > 0 {
      currentItemIndex += 1
    } else if vX < 0 {
      currentItemIndex -= 1
    }
    let nearestPageOffset = currentItemIndex * itemSpace

    return CGPoint(x: nearestPageOffset, y: parent.y)
  }
}


