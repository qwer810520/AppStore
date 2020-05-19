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
  private var appResults = [Result]()

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
    fatchItunesApps()
  }

  // MARK: - Private Methods

  private func fatchItunesApps() {
    Service.shared.fetchApps { results, error in
      if let error = error {
        print("Failed to fetch apps:", error)
      }
      self.appResults = results
      DispatchQueue.main.async {
        self.collectionView.reloadData()
      }
    }
  }
}

  // NARK: - UICollectionViewDataSource

extension AppsSearchController {
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return appResults.count
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? SearchResultCell else {
      fatalError("SearchResultCell Initialization Fail")
    }
    let appResult = appResults[indexPath.item]
    cell.nameLabel.text = appResult.trackName
    cell.categoryLabel.text = appResult.primaryGenreName
    cell.ratingsLabel.text = "Rating: \(appResult.averageUserRating ?? 0)"

//    cell.appIconImageView
//    cell.screenshort1ImageView


    return cell
  }
}

  // MARK: - UICollectionViewDelegateFlowLayout

extension AppsSearchController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return .init(width: view.frame.width, height: 350)
  }
}
