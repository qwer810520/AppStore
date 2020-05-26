//
//  ReviewRowCell.swift
//  AppStore
//
//  Created by Min on 2020/5/25.
//  Copyright © 2020 Min. All rights reserved.
//

import UIKit

class ReviewRowCell: UICollectionViewCell {

  let reviewsController = ReviewsController()

  // MARK: - Initialization

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .systemPink
    addSubview(reviewsController.view)
    reviewsController.view.fillSuperview()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}


