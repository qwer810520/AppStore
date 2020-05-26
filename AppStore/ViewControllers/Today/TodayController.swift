//
//  TodayController.swift
//  AppStore
//
//  Created by Min on 2020/5/26.
//  Copyright © 2020 Min. All rights reserved.
//

import UIKit

class TodayController: BaseListController {

  let cellId = "cellId"

  // MARK: - UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.setNavigationBarHidden(true, animated: false)

    collectionView.backgroundColor = #colorLiteral(red: 0.9489468932, green: 0.9490604997, blue: 0.9489081502, alpha: 1)
    collectionView.register(TodayCell.self, forCellWithReuseIdentifier: cellId)
  }
}

  // MARK: - UICollectionViewDataSource

extension TodayController {
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 4
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? TodayCell else {
      fatalError("TodayCell Initialization Fail")
    }
    return cell
  }
}

  // MARK: - UICollectionViewDelegateFlowLayout

extension TodayController: UICollectionViewDelegateFlowLayout {
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    print("Animate fullscreen somehow...")
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return .init(width: view.frame.width - 64, height: 450)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 32
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return .init(top: 32, left: 0, bottom: 32, right: 0)
  }
}
