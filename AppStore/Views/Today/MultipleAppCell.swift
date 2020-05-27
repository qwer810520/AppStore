//
//  MultipleAppCell.swift
//  AppStore
//
//  Created by Min on 2020/5/27.
//  Copyright © 2020 Min. All rights reserved.
//

import UIKit

class MultipleAppCell: UICollectionViewCell {

  var app: FeedResult? {
    didSet {
      nameLabel.text = app?.name
      companyLabel.text = app?.artistName
      imageView.sd_setImage(with: URL(string: app?.artworkUrl100 ?? ""))
    }
  }

  let imageView: UIImageView = {
    return UIImageView(cornerRadius: 8)
  }()

  let nameLabel: UILabel = {
    return UILabel(text: "App Name", font: .systemFont(ofSize: 20))
  }()

  let companyLabel: UILabel = {
    return UILabel(text: "Company", font: .systemFont(ofSize: 13))
  }()

  let getButton: UIButton = {
    return UIButton(title: "GET")
  }()

  let separatorView: UIView = {
    let view = UIView()
    view.backgroundColor = .init(white: 0.3, alpha: 0.3)
    return view
  }()

  // MARK: - Initialization

  override init(frame: CGRect) {
    super.init(frame: frame)

    imageView.backgroundColor = .purple
    imageView.constrainWidth(constant: 64)
    imageView.constrainHeight(constant: 64)

    getButton.backgroundColor = .init(white: 0.95, alpha: 1)
    getButton.constrainWidth(constant: 80)
    getButton.constrainHeight(constant: 32)
    getButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
    getButton.layer.cornerRadius = 32 / 2

    let stackView = UIStackView(arrangedSubviews: [imageView, VerticalStackView(arrangedSubviews: [nameLabel, companyLabel], spacing: 4), getButton])
    stackView.spacing = 16
    stackView.alignment = .center

    addSubview(stackView)
    stackView.fillSuperview()

    addSubview(separatorView)
    separatorView.anchor(top: nil, leading: nameLabel.leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: -8, right: 0), size: .init(width: 0, height: 0.5))
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}