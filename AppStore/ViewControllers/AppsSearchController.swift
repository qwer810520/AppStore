//
//  AppsSearchController.swift
//  AppStore
//
//  Created by Min on 2020/5/17.
//  Copyright © 2020 Min. All rights reserved.
//

import UIKit

class AppsSearchController: UICollectionViewController {

  fileprivate let cellId = "id1234"

  // MARK: - UIViewController

  init() {
    super.init(collectionViewLayout: UICollectionViewFlowLayout())
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    collectionView.backgroundColor = .white
    collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: cellId)
  }

  // MARK: - Private Methods


}

  // NARK: - UICollectionViewDataSource

extension AppsSearchController {
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 5
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
    
    return cell
  }
}

  // MARK: - UICollectionViewDelegateFlowLayout

extension AppsSearchController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return .init(width: view.frame.width, height: 350)
  }
}
