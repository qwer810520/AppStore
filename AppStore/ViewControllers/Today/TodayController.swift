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
  var startingFrame: CGRect?
  var appFullscreenController: UIViewController?

  // MARK: - UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.setNavigationBarHidden(true, animated: false)

    collectionView.backgroundColor = #colorLiteral(red: 0.9489468932, green: 0.9490604997, blue: 0.9489081502, alpha: 1)
    collectionView.register(TodayCell.self, forCellWithReuseIdentifier: cellId)
  }

  // MARK: - Private Methods

  @objc private func handleRemoveRedView(gesture: UITapGestureRecognizer) {
    UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
      gesture.view?.frame = self.startingFrame ?? .zero
      self.tabBarController?.tabBar.frame.origin.y = self.view.frame.maxY - (self.tabBarController?.tabBar.frame.height ?? 0)
    }, completion: { _ in
      gesture.view?.removeFromSuperview()
      self.appFullscreenController?.removeFromParent()
    })
  }
}

  // MARK: - UICollectionViewDataSource

extension TodayController {
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 4
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? TodayCell else {
      fatalError("TodayCell Initialization Fail")
    }
    return cell
  }
}

  // MARK: - UICollectionViewDelegateFlowLayout

extension TodayController: UICollectionViewDelegateFlowLayout {
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    let appFullscreenController = AppFullscreenController()

    let redView = appFullscreenController.view!
    redView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleRemoveRedView(gesture:))))
    view.addSubview(redView)
    addChild(appFullscreenController)

    self.appFullscreenController = appFullscreenController

    guard let cell = collectionView.cellForItem(at: indexPath) else { return }

    guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else { return }
    self.startingFrame = startingFrame
    redView.frame = startingFrame
    redView.layer.cornerRadius = 16


    UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
      redView.frame = self.view.frame
      self.tabBarController?.tabBar.frame.origin.y = self.view.frame.maxY
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
