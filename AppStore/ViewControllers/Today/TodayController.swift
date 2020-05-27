//
//  TodayController.swift
//  AppStore
//
//  Created by Min on 2020/5/26.
//  Copyright © 2020 Min. All rights reserved.
//

import UIKit

class TodayController: BaseListController {

//  let items = [
//    TodayItem(category: "LIFT HACK", title: "Utilizing your Time", image: UIImage(named: "garden") ?? UIImage(), description: "All the tools and apps you need to intelligently organize your life theright way.", backgroundColor: .white, cellType: .single),
//    TodayItem(category: "THE DAILY LIST", title: "Test-Drive these CarPlay Apps", image: UIImage(named: "garden") ?? UIImage(), description: "", backgroundColor: .white, cellType: .mutltiple),
//    TodayItem(category: "HOLIDAYS", title: "Travel on a Budget", image: UIImage(named: "holiday") ?? UIImage(), description: "Find out all you need to know on how to travel without packing everything", backgroundColor: #colorLiteral(red: 0.9774419665, green: 0.9603155255, blue: 0.7258630395, alpha: 1), cellType: .single),
//    TodayItem(category: "THE DAILY LIST", title: "Test-Drive these CarPlay Apps", image: UIImage(named: "garden") ?? UIImage(), description: "", backgroundColor: .white, cellType: .mutltiple),
//  ]

  var items = [TodayItem]()

  let activityIndicatorView: UIActivityIndicatorView = {
    let view = UIActivityIndicatorView(style: .large)
    view.color = .darkGray
    view.startAnimating()
    view.hidesWhenStopped = true
    return view
  }()

  var startingFrame: CGRect?
  var appFullscreenController: AppFullscreenController?
  var topConstraint: NSLayoutConstraint?
  var leadingConstraint: NSLayoutConstraint?
  var widthConstraint: NSLayoutConstraint?
  var heightConstraint: NSLayoutConstraint?
  static let cellSizeHeight: CGFloat = 500

  // MARK: - UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()

    view.addSubview(activityIndicatorView)
    activityIndicatorView.centerInSuperview()

    fetchData()

    navigationController?.setNavigationBarHidden(true, animated: false)

    collectionView.backgroundColor = #colorLiteral(red: 0.9489468932, green: 0.9490604997, blue: 0.9489081502, alpha: 1)
    collectionView.register(TodayCell.self, forCellWithReuseIdentifier: TodayItem.CellType.single.rawValue)
    collectionView.register(TodayMultipleAppCell.self, forCellWithReuseIdentifier: TodayItem.CellType.mutltiple.rawValue)
  }

  // MARK: - Private Methods

  private func handleRemoveRedView() {
    UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
      
      self.appFullscreenController?.tableView.contentOffset = .zero

      guard let startingFrame = self.startingFrame else { return }

      self.topConstraint?.constant = startingFrame.origin.y
      self.leadingConstraint?.constant = startingFrame.origin.x
      self.widthConstraint?.constant = startingFrame.width
      self.heightConstraint?.constant = startingFrame.height

      self.view.layoutIfNeeded()

      self.tabBarController?.tabBar.frame.origin.y = self.view.frame.maxY - (self.tabBarController?.tabBar.frame.height ?? 0)

      guard let cell = self.appFullscreenController?.tableView.cellForRow(at: [0, 0]) as? AppFullscreenHeaderCell else { return }
      cell.todayCell.topConstraint?.constant = 24
      cell.layoutIfNeeded()
    }, completion: { _ in
      self.appFullscreenController?.view?.removeFromSuperview()
      self.appFullscreenController?.removeFromParent()
      self.collectionView.isUserInteractionEnabled = true
    })
  }

  // MARK: - API Methods

  private func fetchData() {
    let dispathGroup = DispatchGroup()

    var topGrossingGroup: AppGroup?
    var gamesGroup: AppGroup?

    dispathGroup.enter()
    Service.shared.fetchTopGrossing { (appGroup, error) in
      // make sure to check your errors
      topGrossingGroup = appGroup
      dispathGroup.leave()
    }

    dispathGroup.enter()
    Service.shared.fetchGames { (appGroup, error) in
      gamesGroup = appGroup
      dispathGroup.leave()
    }

    dispathGroup.notify(queue: .main) {
      self.activityIndicatorView.stopAnimating()
      self.items = [
        TodayItem(category: "Daily List", title: topGrossingGroup?.feed.title ?? "", image: UIImage(named: "garden") ?? UIImage(), description: "", backgroundColor: .white, cellType: .mutltiple, apps: topGrossingGroup?.feed.results ?? []),
        TodayItem(category: "Daily List", title: gamesGroup?.feed.title ?? "", image: UIImage(named: "garden") ?? UIImage(), description: "", backgroundColor: .white, cellType: .mutltiple, apps: gamesGroup?.feed.results ?? []),
        TodayItem(category: "LIFT HACK", title: "Utilizing your Time", image: UIImage(named: "garden") ?? UIImage(), description: "All the tools and apps you need to intelligently organize your life theright way.", backgroundColor: .white, cellType: .single, apps: []),
        TodayItem(category: "HOLIDAYS", title: "Travel on a Budget", image: UIImage(named: "holiday") ?? UIImage(), description: "Find out all you need to know on how to travel without packing everything", backgroundColor: #colorLiteral(red: 0.9774419665, green: 0.9603155255, blue: 0.7258630395, alpha: 1), cellType: .single, apps: []),
      ]
      self.collectionView.reloadData()
    }
  }

  // MARK: - Action Methods

  @objc private func handleMultipleAppsTap(gesture: UIGestureRecognizer) {

    let collectionView = gesture.view

    var superview = collectionView?.superview
    while superview != nil {
      if let cell = superview as? TodayMultipleAppCell {
        guard let indexPath = self.collectionView.indexPath(for: cell) else { return }

        let apps = self.items[indexPath.item].apps

        let fullController = TodayMultipleAppsController(mode: .fullscreen)
        fullController.apps = apps
        present(fullController, animated: true)

      }
      superview = superview?.superview
    }
  }
}

  // MARK: - UICollectionViewDataSource

extension TodayController {
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return items.count
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cellId = items[indexPath.item].cellType.rawValue
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? BaseTodayCell else {
      fatalError("BaseTodayCell Initialization Fail")
    }
    cell.todayItem = items[indexPath.row]
    (cell as? TodayMultipleAppCell)?.multipleAppViewController.collectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMultipleAppsTap(gesture:))))
    return cell
  }
}

  // MARK: - UICollectionViewDelegateFlowLayout

extension TodayController: UICollectionViewDelegateFlowLayout {
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    if items[indexPath.item].cellType == .mutltiple {
      let fullController = TodayMultipleAppsController(mode: .fullscreen)
      fullController.apps = items[indexPath.item].apps
      let navi = BackEnabledNavigationController(rootViewController: fullController)
      navi.modalPresentationStyle = .fullScreen
      present(navi, animated: true)
      return
    }


    let appFullscreenController = AppFullscreenController()
    appFullscreenController.todayItem = items[indexPath.item]
    appFullscreenController.dismissHandler = { [weak self] in
      self?.handleRemoveRedView()
    }

    let fullscreenView = appFullscreenController.view!
    view.addSubview(fullscreenView)
    addChild(appFullscreenController)

    self.appFullscreenController = appFullscreenController
    self.collectionView.isUserInteractionEnabled = false

    guard let cell = collectionView.cellForItem(at: indexPath) else { return }

    guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else { return }
    self.startingFrame = startingFrame

    fullscreenView.translatesAutoresizingMaskIntoConstraints = false

    topConstraint = fullscreenView.topAnchor.constraint(equalTo: view.topAnchor, constant: startingFrame.origin.y)
    leadingConstraint = fullscreenView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: startingFrame.origin.x)
    widthConstraint = fullscreenView.widthAnchor.constraint(equalToConstant: startingFrame.width)
    heightConstraint = fullscreenView.heightAnchor.constraint(equalToConstant: startingFrame.height)

    [topConstraint, leadingConstraint, widthConstraint, heightConstraint].forEach { $0?.isActive = true }
    self.view.layoutIfNeeded()

    fullscreenView.layer.cornerRadius = 16


    UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {

      self.topConstraint?.constant = 0
      self.leadingConstraint?.constant = 0
      self.widthConstraint?.constant = self.view.frame.width
      self.heightConstraint?.constant = self.view.frame.height

      self.view.layoutIfNeeded()

      self.tabBarController?.tabBar.frame.origin.y = self.view.frame.maxY

      guard let cell = appFullscreenController.tableView.cellForRow(at: [0, 0]) as? AppFullscreenHeaderCell else { return }
      cell.todayCell.topConstraint?.constant = 48
      cell.layoutIfNeeded()
    })
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return .init(width: view.frame.width - 64, height: TodayController.cellSizeHeight)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 32
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return .init(top: 32, left: 0, bottom: 32, right: 0)
  }
}
