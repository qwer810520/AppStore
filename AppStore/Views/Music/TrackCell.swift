//
//  TrackCell.swift
//  AppStore
//
//  Created by Min on 2020/5/30.
//  Copyright © 2020 Min. All rights reserved.
//

import UIKit

class TrackCell: UICollectionViewCell {

  let imageView = UIImageView(cornerRadius: 16)
  let nameLabel = UILabel(text: "Track Name", font: .boldSystemFont(ofSize: 18))
  let subTitleLabel = UILabel(text: "SubTitle Label", font: .systemFont(ofSize: 16), numberOfLines: 2)

  // MARK: - Initialization

  override init(frame: CGRect) {
    super.init(frame: frame)

    imageView.image = #imageLiteral(resourceName: "garden")
    imageView.constrainWidth(constant: 80)

    let stackView = UIStackView(arrangedSubviews: [
      imageView,
      VerticalStackView(arrangedSubviews: [nameLabel, subTitleLabel], spacing: 4)
    ], customSpacing: 16)
    addSubview(stackView)

    stackView.fillSuperview(padding: .init(top: 16, left: 16, bottom: 16, right: 16))
    stackView.alignment = .center
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
