//
//  AppsPageController.swift
//  AppStore
//
//  Created by Min on 2020/5/20.
//  Copyright © 2020 Min. All rights reserved.
//

import UIKit

class AppsPageController: BaseListController {

  let cellId = "id"
  let headerId = "headerId"
  var socialApps = [SocialApp]()
  var groups = [AppGroup]()

  let activityIndicatorView: UIActivityIndicatorView = {
    let aiv = UIActivityIndicatorView(style: .large)
    aiv.color = .black
    aiv.startAnimating()
    aiv.hidesWhenStopped = true
    return aiv
  }()

  // MARK: - UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.backgroundColor = .white

    collectionView.register(AppsGroupCell.self, forCellWithReuseIdentifier: cellId)
    collectionView.register(AppsPageHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)

    view.addSubview(activityIndicatorView)
    activityIndicatorView.fillSuperview()

    fetchData()
  }

  // MARK: - Private Methods

  private func fetchData() {

    var group1: AppGroup?
    var group2: AppGroup?
    var group3: AppGroup?

    let dispatchGroup = DispatchGroup()

    dispatchGroup.enter()
    Service.shared.fetchGames { (appGroup, err) in
      dispatchGroup.leave()
      group1 = appGroup
    }

    dispatchGroup.enter()
    Service.shared.fetchTopGrossing { (appGroup, error) in
      dispatchGroup.leave()
      group2 = appGroup
    }

    dispatchGroup.enter()
    Service.shared.fetchAppGroup(urlString: "https://rss.itunes.apple.com/api/v1/us/ios-apps/top-free/all/50/explicit.json") { (appGroup, error) in
      dispatchGroup.leave()
      group3 = appGroup
    }

    dispatchGroup.enter()
    Service.shared.fetchSocialApps { (apps, error) in
      dispatchGroup.leave()
      self.socialApps = apps ?? []
    }

    dispatchGroup.notify(queue: .main) {
      self.activityIndicatorView.stopAnimating()

      if let group = group1 { self.groups.append(group) }
      if let group = group2 { self.groups.append(group) }
      if let group = group3 { self.groups.append(group) }

      self.collectionView.reloadData()
    }
  }
}

  // MARK: - UICollectionViewDataSource

extension AppsPageController {
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return groups.count
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? AppsGroupCell else {
      fatalError("AppsGroupCell Initialization Fail")
    }
    let appGroup = groups[indexPath.item]

    cell.titleLabel.text = appGroup.feed.title
    cell.horizontalController.appGroup = appGroup
    cell.horizontalController.collectionView.reloadData()
    cell.horizontalController.didSelectHandler = { [weak self] feedResult in
      let detailController = AppDetailController(appId: feedResult.id)
      detailController.navigationItem.title = feedResult.name
      self?.navigationController?.pushViewController(detailController, animated: true)
    }
    return cell
  }
}

  // MARK: - UICollectionViewDelegateFlowLayout

extension AppsPageController: UICollectionViewDelegateFlowLayout {
  override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as? AppsPageHeader else {
      fatalError("AppsPageHeader Initialization Fail")
    }
    header.appHeaderHorizontalController.socialApps = socialApps
    header.appHeaderHorizontalController.collectionView.reloadData()
    return header
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    return .init(width: view.frame.width, height: 300)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return .init(width: view.frame.width, height: 300)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return .init(top: 16, left: 0, bottom: 0, right: 0)
  }
}
