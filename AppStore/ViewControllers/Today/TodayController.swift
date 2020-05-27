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
  let items = [
    TodayItem(category: "LIFT HACK", title: "Utilizing your Time", image: UIImage(named: "garden") ?? UIImage(), description: "All the tools and apps you need to intelligently organize your life theright way.", backgroundColor: .white),
    TodayItem(category: "HOLIDAYS", title: "Travel on a Budget", image: UIImage(named: "holiday") ?? UIImage(), description: "Find out all you need to know on how to travel without packing everything", backgroundColor: #colorLiteral(red: 0.9774419665, green: 0.9603155255, blue: 0.7258630395, alpha: 1))
  ]
  var startingFrame: CGRect?
  var appFullscreenController: AppFullscreenController?
  var topConstraint: NSLayoutConstraint?
  var leadingConstraint: NSLayoutConstraint?
  var widthConstraint: NSLayoutConstraint?
  var heightConstraint: NSLayoutConstraint?

  // MARK: - UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.setNavigationBarHidden(true, animated: false)

    collectionView.backgroundColor = #colorLiteral(red: 0.9489468932, green: 0.9490604997, blue: 0.9489081502, alpha: 1)
    collectionView.register(TodayCell.self, forCellWithReuseIdentifier: cellId)
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
}

  // MARK: - UICollectionViewDataSource

extension TodayController {
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return items.count
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? TodayCell else {
      fatalError("TodayCell Initialization Fail")
    }
    cell.todayItem = items[indexPath.item]
    return cell
  }
}

  // MARK: - UICollectionViewDelegateFlowLayout

extension TodayController: UICollectionViewDelegateFlowLayout {
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

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
    return .init(width: view.frame.width - 64, height: 450)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 32
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return .init(top: 32, left: 0, bottom: 32, right: 0)
  }
}
