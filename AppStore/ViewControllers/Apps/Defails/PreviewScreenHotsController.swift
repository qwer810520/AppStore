//
//  PreviewScreenHotsController.swift
//  AppStore
//
//  Created by Min on 2020/5/25.
//  Copyright © 2020 Min. All rights reserved.
//

import UIKit

class PreviewScreenHotsController: HorizontalSnappingController {

  let cellId = "cellId"
  var app: Result? {
    didSet {
      collectionView.reloadData()
    }
  }

  class ScreensHotCell: UICollectionViewCell {

    let imageView: UIImageView = {
      return UIImageView(cornerRadius: 12)
    }()

    // MARK: - Initialization

    override init(frame: CGRect) {
      super.init(frame: frame)
      addSubview(imageView)
      imageView.fillSuperview()
    }

    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
  }

  // MARK: - UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.backgroundColor = .white
    collectionView.register(ScreensHotCell.self, forCellWithReuseIdentifier: cellId)
    collectionView.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)
  }
}

  // MARK: - UICollectionViewDataSource

extension PreviewScreenHotsController {
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return app?.screenshotUrls.count ?? 0
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? ScreensHotCell else {
      fatalError("ScreensHotCell Initialization Fail")
    }
    cell.imageView.sd_setImage(with: URL(string: app?.screenshotUrls[indexPath.item] ?? ""))
    return cell
  }
}

  // MARK: - UICollectionViewDelegateFlowLayout

extension PreviewScreenHotsController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return .init(width: 250, height: view.frame.height)
  }
}
