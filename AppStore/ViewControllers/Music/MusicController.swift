//
//  MusicController.swift
//  AppStore
//
//  Created by Min on 2020/5/30.
//  Copyright © 2020 Min. All rights reserved.
//

import UIKit

class MusicController: BaseListController {

  let cellId = "cellId"
  let footerId = "footerId"

  var result = [Result]()

  private let searchTerm = "taylor"
  var isPagination = false
  var isDonePagiinatiog = false

  // MARK: - UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.backgroundColor = .white

    collectionView.register(TrackCell.self, forCellWithReuseIdentifier: cellId)
    collectionView.register(MusicLoadingFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerId)

    fetchData()
  }

  // MARK: - API Methods


  private func fetchData() {
    isPagination = true
    let urlString = "https://itunes.apple.com/search?term=\(searchTerm)&offset=\(result.count)&limit=20"
    Service.shared.fetchGenericJSONData(urlString: urlString) { (searchResult: SearchResult?, err) in
      if let error = err {
        print("Failed to paginate data: ", error)
      }

      if let results = searchResult?.results, results.isEmpty {
        self.isDonePagiinatiog = true
      }

      sleep(2)

      self.result += searchResult?.results ?? []
      DispatchQueue.main.async {
        self.collectionView.reloadData()
      }

      self.isPagination = false
    }
  }
}

  // MARK: - UICollectionViewDataSource

extension MusicController {
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return result.count
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? TrackCell else {
      fatalError("TrackCell Initialization Fail")
    }

    let track = result[indexPath.item]

    cell.nameLabel.text = track.trackName
    cell.imageView.sd_setImage(with: URL(string: track.artworkUrl100))
    cell.subTitleLabel.text = "\(track.artistName ?? "") \(track.collectionName ?? "")"

    if indexPath.item == result.count - 1, !isPagination {
      fetchData()
    }

    return cell
  }
}

  // MARK: - UICollectionViewDelegateFlowLayout

extension MusicController: UICollectionViewDelegateFlowLayout {
  override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerId, for: indexPath)
    return footer
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    return .init(width: view.frame.width, height: isDonePagiinatiog ? 0 : 100)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return .init(width: view.frame.width, height: 100)
  }
}
