//
//  AppsHeaderHorizontalController.swift
//  AppStore
//
//  Created by Min on 2020/5/21.
//  Copyright © 2020 Min. All rights reserved.
//

import UIKit

class AppsHeaderHorizontalController: HorizontalSnappingController {

  let cellId = "cellId"
  var socialApps = [SocialApp]()

  // MARK: - UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.backgroundColor = .white

    collectionView.register(AppsHeaderCell.self, forCellWithReuseIdentifier: cellId)
    collectionView.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)

    if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
      layout.scrollDirection = .horizontal
    }
  }
}

  // MARK: - UICollectionViewDataSource

extension AppsHeaderHorizontalController {
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return socialApps.count
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? AppsHeaderCell else {
      fatalError("AppsHeaderCell Initialization Fail")
    }

    let app = socialApps[indexPath.item]

    cell.companyLabel.text = app.name
    cell.titleLabel.text = app.tagline
    cell.imageView.sd_setImage(with: URL(string: app.imageUrl))
    return cell
  }
}

  // MARK: - UICollectionViewDelegateFlowLayout

extension AppsHeaderHorizontalController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return .init(width: view.frame.width - 48, height: view.frame.height)
  }

//  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//    return .init(top: 0, left: 16, bottom: 0, right: 16)
//  }
}
