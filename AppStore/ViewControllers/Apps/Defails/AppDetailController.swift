//
//  AppDetailController.swift
//  AppStore
//
//  Created by Min on 2020/5/25.
//  Copyright © 2020 Min. All rights reserved.
//

import UIKit

class AppDetailController: BaseListController {

  private let appId: String

  init(appId: String) {
    self.appId = appId
    super.init()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  var app: Result?
  var reviews: Reviews?

  let defaulCellId = "defaulCellId"
  let previewCellId = "previewCellId"
  let reviewCellId = "reviewCellId"

  // MARK: - UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.backgroundColor = .white
    collectionView.register(AppDetailCell.self, forCellWithReuseIdentifier: defaulCellId)
    collectionView.register(PreviewCell.self, forCellWithReuseIdentifier: previewCellId)
    collectionView.register(ReviewRowCell.self, forCellWithReuseIdentifier: reviewCellId)
    navigationItem.largeTitleDisplayMode = .never
    fetchData()
  }

  // MARK: - Private Methods

  private func fetchData() {
    let urlString = "https://itunes.apple.com/lookup?id=\(appId)"
    Service.shared.fetchGenericJSONData(urlString: urlString) { (result: SearchResult?, error) in
      self.app = result?.results.first
      DispatchQueue.main.async {
        self.collectionView.reloadData()
      }
    }

    let reviewsURL = "https://itunes.apple.com/rss/customerreviews/page=1/id=\(appId)/sortby=mostrecent/json?l=en&cc=us"
    Service.shared.fetchGenericJSONData(urlString: reviewsURL) { (result: Reviews?, err) in
      if let err = err {
        print("Failed to decode reviews: ", err)
      }
      self.reviews = result
      DispatchQueue.main.async {
        self.collectionView.reloadData()
      }
    }
  }
}

  // MARK: - UICollectionViewDataSource

extension AppDetailController {
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 3
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    switch indexPath.item {
      case 0:
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: defaulCellId, for: indexPath) as? AppDetailCell else {
          fatalError("AppDetailCell Initialization Fail")
        }
        cell.app = app
        return cell
      case 1:
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: previewCellId, for: indexPath) as? PreviewCell else {
          fatalError("AppDetailCell Initialization Fail")
        }
        cell.horizontalController.app = app
        return cell
      default:
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reviewCellId, for: indexPath) as? ReviewRowCell else {
          fatalError("ReviewRowCell Initialization Fail")
        }
        cell.reviewsController.reviews = reviews
        return cell
    }
  }
}

  // MARK: - UICollectionViewDelegateFlowLayout

extension AppDetailController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    var height: CGFloat = 280
    switch indexPath.item {
      case 0:
        let dummyCell = AppDetailCell(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 1000))

           dummyCell.app = app
           dummyCell.layoutIfNeeded()

           let estimatedSize = dummyCell.systemLayoutSizeFitting(.init(width: view.frame.width, height: 1000))
        height = estimatedSize.height
      case 1:
        height = 500
      default:
        height = 280
    }
    return .init(width: view.frame.width, height: height)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return .init(top: 0, left: 0, bottom: 16, right: 0)
  }
}
