//
//  AppsCompositionalView.swift
//  AppStore
//
//  Created by Min on 2020/5/30.
//  Copyright © 2020 Min. All rights reserved.
//

import SwiftUI

class CompositionalController: UICollectionViewController {

  init() {

    let layout = UICollectionViewCompositionalLayout { (sectionNumber, _) -> NSCollectionLayoutSection? in
      switch sectionNumber {
        case 0:
          return CompositionalController.topSection()
        default:
          let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/3)))
          item.contentInsets = .init(top: 0, leading: 0, bottom: 16, trailing: 16)
          let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(300)), subitems: [item])
          let section = NSCollectionLayoutSection(group: group)
          section.orthogonalScrollingBehavior = .groupPaging
          section.contentInsets.leading = 16
          section.boundarySupplementaryItems = [
            .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
          ]
          return section
      }
    }
    super.init(collectionViewLayout: layout)
  }

  lazy var diffanleDataSource: UICollectionViewDiffableDataSource<AppSection, AnyHashable> = .init(collectionView: self.collectionView) { (collectionView, indexPath, object) -> UICollectionViewCell? in
    if let app = object as? SocialApp {
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as? AppsHeaderCell else {
        fatalError("AppsHeaderCell Initialization Fail")
      }
      cell.app = app
      return cell
    } else if let app = object as? FeedResult {
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "smallCellId", for: indexPath) as? AppRowCell else {
        fatalError("AppRowCell Initialization Fail")
      }
      cell.app = app
      cell.getButton.addTarget(self, action: #selector(self.handleGet), for: .primaryActionTriggered)
      return cell
    }
    return nil
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  class CompositionalHeader: UICollectionReusableView {

    let label = UILabel(text: "Editor's Choise Games", font: .boldSystemFont(ofSize: 32))

    // MARK: - Initialization

    override init(frame: CGRect) {
      super.init(frame: frame)
      addSubview(label)
      label.fillSuperview()
    }

    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
  }

  enum AppSection {
    case topSocial, grossing, games, topFree
  }

  let headerId = "headerId"
  var socialApps = [SocialApp]()
  var games = [AppGroup]()

  // MARK: - UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.backgroundColor = .systemBackground
    navigationItem.title = "Apps"
    navigationController?.navigationBar.prefersLargeTitles = true

    collectionView.register(AppsHeaderCell.self, forCellWithReuseIdentifier: "cellId")
    collectionView.register(AppRowCell.self, forCellWithReuseIdentifier: "smallCellId")
    collectionView.register(CompositionalHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)

    navigationItem.rightBarButtonItem = .init(title: "Fetch Top Free", style: .plain, target: self, action: #selector(handleFetchTopFree))

    collectionView.refreshControl = UIRefreshControl()
    collectionView.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)

//    fetchApps()
    setupDiffanleDataSource()
  }

  // MARK: - Private Methods

  private func setupDiffanleDataSource() {
    collectionView.dataSource = diffanleDataSource

    diffanleDataSource.supplementaryViewProvider = .some({ (collectionView, kind, indexPath) -> UICollectionReusableView? in
      guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.headerId, for: indexPath) as? CompositionalHeader else {
        fatalError("CompositionalHeader Initialization Fail")
      }

      let snapshot = self.diffanleDataSource.snapshot()
      if let object = self.diffanleDataSource.itemIdentifier(for: indexPath), let section = snapshot.sectionIdentifier(containingItem: object) {
        switch section {
          case .games:
            header.label.text = "Games"
          case .grossing:
            header.label.text = "Top Grossing"
          case .topFree:
            header.label.text = "Top Free"
          default: break
        }
      }

      return header
    })

    Service.shared.fetchSocialApps { (apps, error) in
      Service.shared.fetchTopGrossing { (appGroup, error) in
        Service.shared.fetchGames { (gameGroup, error) in
          var snapsshot = self.diffanleDataSource.snapshot()
          snapsshot.appendSections([.topSocial, .games, .grossing ])
          snapsshot.appendItems(apps ?? [], toSection: .topSocial)
          snapsshot.appendItems(appGroup?.feed.results ?? [], toSection: .grossing)
          snapsshot.appendItems(gameGroup?.feed.results ?? [], toSection: .games)

          self.diffanleDataSource.apply(snapsshot)
        }
      }
    }
  }

  static func topSection() -> NSCollectionLayoutSection {
    let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
       item.contentInsets.bottom = 16
       item.contentInsets.trailing = 16
       let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(300)), subitems: [item])
       let section = NSCollectionLayoutSection(group: group)
       section.orthogonalScrollingBehavior = .groupPaging
       section.contentInsets.leading = 16
    return section
  }

  // MARK: - API Methods

  private func fetchApps() {

    let dispatchGroup = DispatchGroup()

    var group1: AppGroup?
    var group2: AppGroup?
    var group3: AppGroup?

    dispatchGroup.enter()
    Service.shared.fetchSocialApps { (socialApps, error
      ) in
      dispatchGroup.leave()
      self.socialApps = socialApps ?? []
    }

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

    dispatchGroup.notify(queue: .main) {
      if let group = group1 { self.games.append(group) }
      if let group = group2 { self.games.append(group) }
      if let group = group3 { self.games.append(group) }

      self.collectionView.reloadData()
    }
  }

  // MARK: - Action Methods

  @objc private func handleGet(button: UIView) {
    var superview = button.superview

    while superview != nil {
      if let cell = superview as? UICollectionViewCell {
        guard let indexPath = collectionView.indexPath(for: cell), let objectIClickedOnto = diffanleDataSource.itemIdentifier(for: indexPath) else { return }
        print("objectIClickedOnto: \(objectIClickedOnto)")
        var snapshot = diffanleDataSource.snapshot()
        snapshot.deleteItems([objectIClickedOnto])
        diffanleDataSource.apply(snapshot)
      }
      superview = superview?.superview
    }
  }

  @objc private func handleFetchTopFree() {
    Service.shared.fetchAppGroup(urlString: "https://rss.itunes.apple.com/api/v1/us/ios-apps/top-free/all/50/explicit.json") { (appGroup, error) in
      var snapshot = self.diffanleDataSource.snapshot()
      snapshot.insertSections([.topFree], afterSection: .topSocial)
      snapshot.appendItems(appGroup?.feed.results ?? [], toSection: .topFree)
      self.diffanleDataSource.apply(snapshot)
    }
  }

  @objc private func handleRefresh() {
    collectionView.refreshControl?.endRefreshing()
    var snapshot = diffanleDataSource.snapshot()
    snapshot.deleteSections([.topFree, .games, .grossing])
    

    diffanleDataSource.apply(snapshot)
  }
}

  // MARK: - UICollectionViewDelegate

extension CompositionalController {
  override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as? CompositionalHeader else {
      fatalError("CompositionalHeader Initialization Fail")
    }
    header.label.text = games[indexPath.section - 1].feed.title
    return header
  }

  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    var appId = ""
    /*
    switch indexPath.section {
      case 0:
        appId = socialApps[indexPath.item].id
      case 1:
        appId = games[indexPath.section - 1].feed.results[indexPath.item].id
      default: break
    }
     */
    let object = diffanleDataSource.itemIdentifier(for: indexPath)
    if let object = object as? SocialApp {
      appId = object.id
    } else if let object = object as? FeedResult {
      appId = object.id
    }
    let appDetailController = AppDetailController(appId: appId)
    navigationController?.pushViewController(appDetailController, animated: true)
  }
}

  // MARK: - UICollectionViewDataSource

extension CompositionalController {
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
//    return games.count + 1
    return 0
  }
  /*
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch section {
      case 0:
        return socialApps.count
      default:
        return games[section - 1].feed.results.count
    }
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    switch indexPath.section {
      case 0:
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as? AppsHeaderCell else {
          fatalError("AppsHeaderCell Initialization Fail")
        }
        let app = socialApps[indexPath.item]
        cell.titleLabel.text = app.tagline
        cell.companyLabel.text = app.name
        cell.imageView.sd_setImage(with: URL(string: app.imageUrl) )
        return cell
      default:
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "smallCellId", for: indexPath) as? AppRowCell else {
          fatalError("AppRowCell Initialization Fail")
        }
        let app = games[indexPath.section - 1].feed.results[indexPath.item]
        cell.nameLabel.text = app.name
        cell.companyLabel.text = app.artistName
        cell.imageView.sd_setImage(with: URL(string: app.artworkUrl100))
        return cell
    }
  }
  */
}

  // MARK: - UIViewControllerRepresentable

struct AppsView: UIViewControllerRepresentable {

  typealias UIViewControllerType = UIViewController

  func makeUIViewController(context: Context) -> UIViewController {
    let controller = CompositionalController()
    return UINavigationController(rootViewController: controller)
  }

  func updateUIViewController(_ uiViewController: UIViewController, context: Context) {

  }
}

struct AppsCompositionalView_Previews: PreviewProvider {
    static var previews: some View {
      AppsView().edgesIgnoringSafeArea(.all)
    }
}
