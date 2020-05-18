//
//  SearchResultCell.swift
//  AppStore
//
//  Created by Min on 2020/5/17.
//  Copyright © 2020 Min. All rights reserved.
//

import UIKit

class SearchResultCell: UICollectionViewCell {

  let imageView: UIImageView = {
    let view = UIImageView()
    view.backgroundColor = .red
    view.widthAnchor.constraint(equalToConstant: 64).isActive = true
    view.heightAnchor.constraint(equalToConstant: 64).isActive = true
    view.layer.cornerRadius = 12
    return view
  }()

  let nameLabel: UILabel = {
    let label = UILabel()
    label.text = "App Name"
    return label
  }()

  let categoryLabel: UILabel = {
    let label = UILabel()
    label.text = "Photo & Video"
    return label
  }()

  let ratingsLabel: UILabel = {
    let label = UILabel()
    label.text = "9.26M"
    return label
  }()

  let getButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Get", for: .normal)
    button.setTitleColor(.blue, for: .normal)
    button.titleLabel?.font = .boldSystemFont(ofSize: 14)
    button.backgroundColor = UIColor(white: 0.95, alpha: 1)
    button.widthAnchor.constraint(equalToConstant: 80).isActive = true
    button.heightAnchor.constraint(equalToConstant: 32).isActive = true
    button.layer.cornerRadius = 16
    return button
  }()

  lazy var screenshort1ImageView = self.createScreenshotImageView()
  lazy var screenshort2ImageView = self.createScreenshotImageView()
  lazy var screenshort3ImageView = self.createScreenshotImageView()


  // MARK: - Initialzation

  override init(frame: CGRect) {
    super.init(frame: frame)

    let infoTopStackView = UIStackView(arrangedSubviews: [imageView, VerticalStackView(arrangedSubviews: [nameLabel, categoryLabel, ratingsLabel]), getButton])
    infoTopStackView.spacing = 12
    infoTopStackView.alignment = .center

    let screensshotsStackView = UIStackView(arrangedSubviews: [screenshort1ImageView, screenshort2ImageView, screenshort3ImageView])
    screensshotsStackView.spacing = 12
    screensshotsStackView.distribution = .fillEqually

    let overallStachView = VerticalStackView(arrangedSubviews: [infoTopStackView, screensshotsStackView], spacing: 16)

    addSubview(overallStachView)
    overallStachView.fillSuperview(padding: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Private Methods

  private func createScreenshotImageView() -> UIImageView {
    let imageView = UIImageView()
    imageView.backgroundColor = .blue
    return imageView
  }
}


