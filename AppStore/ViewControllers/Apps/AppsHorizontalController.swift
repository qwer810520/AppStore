//
//  AppsHorizontalController.swift
//  AppStore
//
//  Created by Min on 2020/5/20.
//  Copyright © 2020 Min. All rights reserved.
//

import UIKit

class AppsHorizontalController: HorizontalSnappingController {

  let cellId = "cellId"
  let topBottomPadding: CGFloat = 12
  let lineSpacing: CGFloat = 10
  var appGroup: AppGroup?
  var didSelectHandler: ((FeedResult) -> Void)?

  override func viewDidLoad() {
    super.viewDidLoad()

    collectionView.backgroundColor = .white

    collectionView.register(AppRowCell.self, forCellWithReuseIdentifier: "cellId")
    collectionView.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)

    if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
      layout.scrollDirection = .horizontal
    }
  }
}

  // MARK: - UICollectionViewDataSource

extension AppsHorizontalController {
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return appGroup?.feed.results.count ?? 0
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as? AppRowCell else {
      fatalError("AppRowCell Initialization Fail")
    }
    let app = appGroup?.feed.results[indexPath.item]
    cell.nameLabel.text = app?.name
    cell.companyLabel.text = app?.name
    cell.imageView.sd_setImage(with: URL(string: app?.artworkUrl100 ?? ""))
    return cell
  }
}

  // MARK: - UICollectionViewDelegateFlowLayout

extension AppsHorizontalController: UICollectionViewDelegateFlowLayout {
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let app = appGroup?.feed.results[indexPath.item] else { return }
    didSelectHandler?(app)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let height = (view.frame.height - topBottomPadding * 2 - lineSpacing * 2) / 3
    return .init(width: view.frame.width - 48, height: height)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return lineSpacing
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return .init(top: topBottomPadding, left: 0, bottom: topBottomPadding, right: 0)
  }
}
