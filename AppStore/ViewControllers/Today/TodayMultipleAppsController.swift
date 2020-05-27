//
//  TodayMultipleAppsController.swift
//  AppStore
//
//  Created by Min on 2020/5/27.
//  Copyright © 2020 Min. All rights reserved.
//

import UIKit

class TodayMultipleAppsController: BaseListController {

  let cellId = "cellId"
  var results = [FeedResult]()

  let closeButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(named: "close_button"), for: .normal)
    button.tintColor = .darkGray
    button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
    return button
  }()

  private let spacing: CGFloat = 16
  fileprivate let mode: Mode

  enum Mode {
    case small, fullscreen
  }

  // MARK: - UIViewController

  override var prefersStatusBarHidden: Bool { return true }

  init(mode: Mode) {
    self.mode = mode
    super.init()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    collectionView.backgroundColor = .white
    collectionView.isScrollEnabled = mode == .fullscreen

    collectionView.register(MultipleAppCell.self, forCellWithReuseIdentifier: cellId)

    if mode == .fullscreen {
      setUpCloseButton()
    }
  }

  // MARK: - Private Methods

  private func setUpCloseButton() {
    view.addSubview(closeButton)
    closeButton.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 16), size: .init(width: 44, height: 44))
  }

  // MARK: - Action Methods

  @objc private func handleDismiss() {
    dismiss(animated: true)
  }
}

  // MARK: - UICollectionViewDataSource

extension TodayMultipleAppsController {
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return mode == .small ? min(4, results.count) : results.count
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? MultipleAppCell else {
      fatalError("MultipleAppCell Initialization Fail")
    }
    cell.app = results[indexPath.item]
    return cell
  }
}

  // MARK: - UICollectionViewDelegateFlowLayout

extension TodayMultipleAppsController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return mode == .small ? .init(width: view.frame.width, height: (view.frame.height - 3 * spacing) / 4) : .init(width: view.frame.width - 48, height: 68)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return spacing
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return mode == .fullscreen ? .init(top: 12, left: 24, bottom: 12, right: 24) : .zero
  }
}
