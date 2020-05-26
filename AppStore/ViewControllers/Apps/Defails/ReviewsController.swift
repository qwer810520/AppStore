//
//  ReviewsController.swift
//  AppStore
//
//  Created by Min on 2020/5/25.
//  Copyright © 2020 Min. All rights reserved.
//

import UIKit

class ReviewsController: HorizontalSnappingController {

  let cellId = "cellId"
  var reviews: Reviews? {
    didSet {
      collectionView.reloadData()
    }
  }

  // MARK: - UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.backgroundColor = .white
    collectionView.register(ReviewCell.self, forCellWithReuseIdentifier: cellId)
    collectionView.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)
  }
}

  // MARK: - UICollectionViewDataSource

extension ReviewsController {
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return reviews?.feed.entry.count ?? 0
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? ReviewCell else {
      fatalError("ReviewCell Initialization Fail")
    }
    let entry = reviews?.feed.entry[indexPath.item]
    cell.titleLabel.text = entry?.title.label
    cell.authorLabel.text = entry?.author.name.label
    cell.bodyLabel.text = entry?.content.label
    for (index, view) in cell.starsStackView.arrangedSubviews.enumerated() {
      if let ratingInt = Int(entry?.rating.label ?? "0") {
        view.alpha = index >= ratingInt ? 0 : 1
      }
    }
    return cell
  }
}

  // MARK: - UICollectionViewDelegateFlowLayout

extension ReviewsController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return .init(width: view.frame.width - 48, height: view.frame.height)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 16
  }
}
