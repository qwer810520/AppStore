//
//  AppsHeaderCell.swift
//  AppStore
//
//  Created by Min on 2020/5/21.
//  Copyright © 2020 Min. All rights reserved.
//

import UIKit

class AppsHeaderCell: UICollectionViewCell {

  var app: SocialApp? {
    didSet {
      guard let app = app else { return }
      companyLabel.text = app.name
      titleLabel.text = app.tagline
      imageView.sd_setImage(with: URL(string: app.imageUrl))
    }
  }

  let companyLabel: UILabel = {
    let label = UILabel(text: "Facebook", font: .boldSystemFont(ofSize: 12))
    label.textColor = .blue
    return label
  }()

  let titleLabel: UILabel = {
    let label = UILabel(text: "Keeping up with friends is faster than ever", font: .systemFont(ofSize: 24))
    label.numberOfLines = 0
    return label
  }()

  let imageView: UIImageView = {
    return UIImageView(cornerRadius: 8)
  }()

  // MARK: - Initialization

  override init(frame: CGRect) {
    super.init(frame: frame)

    let stackView = VerticalStackView(arrangedSubviews: [companyLabel, titleLabel, imageView], spacing: 12)
    addSubview(stackView)
    stackView.fillSuperview(padding: UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0))
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
