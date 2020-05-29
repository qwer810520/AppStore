//
//  TodayController.swift
//  AppStore
//
//  Created by Min on 2020/5/26.
//  Copyright © 2020 Min. All rights reserved.
//

import UIKit

class TodayController: BaseListController {

  var items = [TodayItem]()

  let activityIndicatorView: UIActivityIndicatorView = {
    let view = UIActivityIndicatorView(style: .large)
    view.color = .darkGray
    view.startAnimating()
    view.hidesWhenStopped = true
    return view
  }()

  let blurVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))

  var startingFrame: CGRect?
  var appFullscreenController: AppFullscreenController?
  var anchoredCOnstraints: AnchoredConstraints?
  var appFullscreenBeginOffset: CGFloat = 0
  static let cellSizeHeight: CGFloat = 500

  // MARK: - UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()

    view.addSubview(activityIndicatorView)
    view.addSubview(blurVisualEffectView)
    blurVisualEffectView.fillSuperview()
    blurVisualEffectView.alpha = 0

    activityIndicatorView.centerInSuperview()

    fetchData()

    navigationController?.setNavigationBarHidden(true, animated: false)

    collectionView.backgroundColor = #colorLiteral(red: 0.9489468932, green: 0.9490604997, blue: 0.9489081502, alpha: 1)
    collectionView.register(TodayCell.self, forCellWithReuseIdentifier: TodayItem.CellType.single.rawValue)
    collectionView.register(TodayMultipleAppCell.self, forCellWithReuseIdentifier: TodayItem.CellType.mutltiple.rawValue)
  }

  // MARK: - Private Methods

  private func handleAppFullscreenDismissal() {
    UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
      
      self.appFullscreenController?.tableView.contentOffset = .zero

      guard let startingFrame = self.startingFrame else { return }

      self.blurVisualEffectView.alpha = 0
      self.appFullscreenController?.view.transform = .identity

      self.anchoredCOnstraints?.top?.constant = startingFrame.origin.y
      self.anchoredCOnstraints?.leading?.constant = startingFrame.origin.x
      self.anchoredCOnstraints?.width?.constant = startingFrame.width
      self.anchoredCOnstraints?.height?.constant = startingFrame.height

      self.view.layoutIfNeeded()

      self.tabBarController?.tabBar.frame.origin.y = self.view.frame.maxY - (self.tabBarController?.tabBar.frame.height ?? 0)

      guard let cell = self.appFullscreenController?.tableView.cellForRow(at: [0, 0]) as? AppFullscreenHeaderCell else { return }
      self.appFullscreenController?.closeButton.alpha = 0
      cell.todayCell.topConstraint?.constant = 24
      cell.layoutIfNeeded()
    }, completion: { _ in
      self.appFullscreenController?.view?.removeFromSuperview()
      self.appFullscreenController?.removeFromParent()
      self.collectionView.isUserInteractionEnabled = true
    })
  }

  private func showDailyListFullScreen(_ indexPath: IndexPath) {
     let fullController = TodayMultipleAppsController(mode: .fullscreen)
     fullController.apps = items[indexPath.item].apps
     let navi = BackEnabledNavigationController(rootViewController: fullController)
     navi.modalPresentationStyle = .fullScreen
     present(navi, animated: true)
   }

  private func setupSingleAppFullscreenController(_ indexPath: IndexPath) {
    let appFullscreenController = AppFullscreenController()
    appFullscreenController.todayItem = items[indexPath.item]
    appFullscreenController.dismissHandler = { [weak self] in
      self?.handleAppFullscreenDismissal()
    }

    appFullscreenController.view.layer.cornerRadius = 16
    self.appFullscreenController = appFullscreenController

    // #1 setup our pan gesture
    let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleDrag))
    gesture.delegate = self
    appFullscreenController.view.addGestureRecognizer(gesture)
  }

  private func setupStartingCellFrame(_ indexPath: IndexPath) {
    guard let cell = collectionView.cellForItem(at: indexPath) else { return }
    guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else { return }
    self.startingFrame = startingFrame
  }

  private func setupAppFullscreenStartingPosition(_ indexPath: IndexPath) {
    let fullscreenView = appFullscreenController!.view!
    view.addSubview(fullscreenView)
    addChild(appFullscreenController!)

    self.collectionView.isUserInteractionEnabled = false

    setupStartingCellFrame(indexPath)

    guard let startingFrame = startingFrame else { return }

    fullscreenView.translatesAutoresizingMaskIntoConstraints = false

    self.anchoredCOnstraints = fullscreenView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: startingFrame.origin.y, left: startingFrame.origin.x, bottom: 0, right: 0), size: startingFrame.size)

    self.view.layoutIfNeeded()
  }

  private func beginAnimationAppFullscreen() {
    UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
      self.blurVisualEffectView.alpha = 1
      self.anchoredCOnstraints?.top?.constant = 0
      self.anchoredCOnstraints?.leading?.constant = 0
      self.anchoredCOnstraints?.width?.constant = self.view.frame.width
      self.anchoredCOnstraints?.height?.constant = self.view.frame.height

      self.view.layoutIfNeeded()

      self.tabBarController?.tabBar.frame.origin.y = self.view.frame.maxY

      guard let cell = self.appFullscreenController!.tableView.cellForRow(at: [0, 0]) as? AppFullscreenHeaderCell else { return }
      cell.todayCell.topConstraint?.constant = 48
      cell.layoutIfNeeded()
    })
  }

  private func showSingleAppFullscreen(indexPath: IndexPath) {
    // #1
    setupSingleAppFullscreenController(indexPath)

    // #2 setup fullscreen in its starting position
    setupAppFullscreenStartingPosition(indexPath)

    // #3 begin the fullscreen animation
    beginAnimationAppFullscreen()
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
        TodayItem(category: "LIFT HACK", title: "Utilizing your Time", image: UIImage(named: "garden") ?? UIImage(), description: "All the tools and apps you need to intelligently organize your life theright way.", backgroundColor: .white, cellType: .single, apps: []),
        TodayItem(category: "Daily List", title: topGrossingGroup?.feed.title ?? "", image: UIImage(named: "garden") ?? UIImage(), description: "", backgroundColor: .white, cellType: .mutltiple, apps: topGrossingGroup?.feed.results ?? []),
        TodayItem(category: "Daily List", title: gamesGroup?.feed.title ?? "", image: UIImage(named: "garden") ?? UIImage(), description: "", backgroundColor: .white, cellType: .mutltiple, apps: gamesGroup?.feed.results ?? []),
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
        let navi = BackEnabledNavigationController(rootViewController: fullController)
        navi.modalPresentationStyle = .fullScreen
        present(navi, animated: true)
      }
      superview = superview?.superview
    }
  }

  @objc private func handleDrag(gesture: UIPanGestureRecognizer) {
    if gesture.state == .began {
      appFullscreenBeginOffset = appFullscreenController?.tableView.contentOffset.y ?? 0
    }

    guard (appFullscreenController?.tableView.contentOffset.y ?? 0) <= CGFloat(0) else { return }
    let translationY = gesture.translation(in: appFullscreenController?.view).y

    guard translationY > 0 else { return }
    switch gesture.state {
      case .ended:
        handleAppFullscreenDismissal()
      case .changed:
        let trueOffset = translationY - appFullscreenBeginOffset
        var scale = 1 - trueOffset / 1000

        scale = min(1, scale)
        scale = max(0.5, scale)
        
        let transform = CGAffineTransform(scaleX: scale, y: scale)
        self.appFullscreenController?.view.transform = transform
      default: break
    }
  }
}

  // MARK: - UIGestureRecognizerDelegate

extension TodayController: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
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
    switch items[indexPath.item].cellType {
      case .mutltiple:
        showDailyListFullScreen(indexPath)
      default:
        showSingleAppFullscreen(indexPath: indexPath)
    }
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
