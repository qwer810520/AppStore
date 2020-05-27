//
//  TodayMultipleAppsController.swift
//  AppStore
//
//  Created by Min on 2020/5/27.
//  Copyright © 2020 Min. All rights reserved.
//

import UIKit

class TodayMultipleAppsController: BaseListController {

  let cellId = "cellId"
  var results = [FeedResult]()
  private let spacing: CGFloat = 16


  // MARK: - UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()

    collectionView.backgroundColor = .white
    collectionView.isScrollEnabled = false

    collectionView.register(MultipleAppCell.self, forCellWithReuseIdentifier: cellId)

  }
}

  // MARK: - UICollectionViewDataSource

extension TodayMultipleAppsController {
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return min(4, results.count)
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? MultipleAppCell else {
      fatalError("MultipleAppCell Initialization Fail")
    }
    cell.app = results[indexPath.item]
    return cell
  }
}

  // MARK: - UICollectionViewDelegateFlowLayout

extension TodayMultipleAppsController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let height: CGFloat = (view.frame.height - 3 * spacing) / 4
    return .init(width: view.frame.width, height: height)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return spacing
  }
}
