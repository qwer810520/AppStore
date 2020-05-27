//
//  TodayMultipleAppCell.swift
//  AppStore
//
//  Created by Min on 2020/5/27.
//  Copyright © 2020 Min. All rights reserved.
//

import UIKit

class TodayMultipleAppCell: BaseTodayCell {

  override var todayItem: TodayItem? {
    didSet {
      categoryLabel.text = todayItem?.category
      titleLabel.text = todayItem?.title

      multipleAppViewController.apps = todayItem?.apps ?? []
      multipleAppViewController.collectionView.reloadData()
    }
  }

  let categoryLabel = UILabel(text: "LIFT HACK", font: .boldSystemFont(ofSize: 20))
  let titleLabel = UILabel(text: "Utilizing your Time", font: .boldSystemFont(ofSize: 32), numberOfLines: 3)

  let multipleAppViewController = TodayMultipleAppsController(mode: .small)

  // MARK: - Initialization

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .white
    layer.cornerRadius = 16

    let stackView = VerticalStackView(arrangedSubviews: [
      categoryLabel,
      titleLabel,
      multipleAppViewController.view
    ], spacing: 12)

    addSubview(stackView)
    stackView.fillSuperview(padding: .init(top: 24, left: 24, bottom: 24, right: 24))
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
