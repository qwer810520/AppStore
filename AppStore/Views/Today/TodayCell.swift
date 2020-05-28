//
//  TodayCell.swift
//  AppStore
//
//  Created by Min on 2020/5/26.
//  Copyright © 2020 Min. All rights reserved.
//

import UIKit

class TodayCell: BaseTodayCell {

  override var todayItem: TodayItem? {
    didSet {
      guard let todayItem = todayItem else { return }
      categoryLabel.text = todayItem.category
      titleLabel.text = todayItem.title
      imageView.image = todayItem.image
      descriptionLabel.text = todayItem.description

      backgroundColor = todayItem.backgroundColor
      backgroundView?.backgroundColor = todayItem.backgroundColor
    }
  }

  var topConstraint: NSLayoutConstraint?

  let categoryLabel = UILabel(text: "LIFT HACK", font: .boldSystemFont(ofSize: 20))
  let titleLabel = UILabel(text: "Utilizing your Time", font: .boldSystemFont(ofSize: 28))

  let imageView = UIImageView(image: UIImage(named: "garden"))

  let descriptionLabel = UILabel(text: "All the tools and apps you need to intelligently organize your life theright way.", font: .systemFont(ofSize: 16), numberOfLines: 3)


  // MARK: - Initialization

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .white
    layer.cornerRadius = 16

    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true

    let imageContainerView = UIView()
    imageContainerView.addSubview(imageView)
    imageView.centerInSuperview(size: .init(width: 240, height: 240))

    let stackView = VerticalStackView(arrangedSubviews: [
      categoryLabel,
      titleLabel,
      imageContainerView,
      descriptionLabel
    ], spacing: 8)

    addSubview(stackView)
    stackView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 24, left: 24, bottom: 24, right: 24))
    topConstraint = stackView.topAnchor.constraint(equalTo: topAnchor, constant: 24)
    topConstraint?.isActive = true
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
