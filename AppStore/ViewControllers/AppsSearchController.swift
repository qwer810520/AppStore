//
//  AppsSearchController.swift
//  AppStore
//
//  Created by Min on 2020/5/17.
//  Copyright © 2020 Min. All rights reserved.
//

import UIKit
import SDWebImage

class AppsSearchController: UICollectionViewController {

  fileprivate let cellId = "id1234"
  private var appResults = [Result]()
  private var timer: Timer?

  private let searchController = UISearchController(searchResultsController: nil)
  private let enterSearchTremLabel: UILabel = {
    let label = UILabel()
    label.text = "Please enter search term above..."
    label.textAlignment = .center
    label.font = UIFont.boldSystemFont(ofSize: 20)
    return label
  }()

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

    view.addSubview(enterSearchTremLabel)
    enterSearchTremLabel.fillSuperview()
    setUpSearchBar()
//    fatchItunesApps()
  }

  // MARK: - Private Methods

  private func setUpSearchBar() {
    definesPresentationContext = true
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
    searchController.searchBar.delegate = self
  }

  // MARK: - API Methods

  private func fatchItunesApps() {
    Service.shared.fetchApps(searchTerm: "Twitter") { results, error in
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
    enterSearchTremLabel.isHidden = !appResults.isEmpty
    return appResults.count
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? SearchResultCell else {
      fatalError("SearchResultCell Initialization Fail")
    }
    cell.appResult = appResults[indexPath.item]
    return cell
  }
}

  // MARK: - UICollectionViewDelegateFlowLayout

extension AppsSearchController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return .init(width: view.frame.width, height: 350)
  }
}

  // MARK: - UISearchBarDelegate

extension AppsSearchController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    print(searchText)

    timer?.invalidate()
    timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
      Service.shared.fetchApps(searchTerm: searchText) { (res, error) in
        self.appResults = res
        DispatchQueue.main.async {
          self.collectionView.reloadData()
        }
      }
    })
  }
}
