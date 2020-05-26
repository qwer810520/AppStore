//
//  ReviewCell.swift
//  AppStore
//
//  Created by Min on 2020/5/25.
//  Copyright © 2020 Min. All rights reserved.
//

import UIKit

class ReviewCell: UICollectionViewCell {

  let titleLabel = UILabel(text: "Review Title", font: .boldSystemFont(ofSize: 18))
  let authorLabel = UILabel(text: "Author", font: .systemFont(ofSize: 16))
  let startLabel = UILabel(text: "Starts", font: .systemFont(ofSize: 14))

  let starsStackView: UIStackView = {
    var arrangedSubviews = [UIView]()
    (0..<5).forEach { _ in
      let imageView = UIImageView(image: UIImage(named: "star"))
      imageView.constrainWidth(constant: 24)
      imageView.constrainHeight(constant: 24)
      arrangedSubviews.append(imageView)
    }
    arrangedSubviews.append(UIView())
    let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
    return stackView
  }()

  let bodyLabel = UILabel(text: "Review body\nReview body\nReview body\n", font: .systemFont(ofSize: 18), numberOfLines: 5)

  // MARK: - Initialization

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = #colorLiteral(red: 0.9450011849, green: 0.9406232238, blue: 0.9736520648, alpha: 1)
    layer.cornerRadius = 16
    clipsToBounds = true

    let stackView = VerticalStackView(arrangedSubviews: [
      UIStackView(arrangedSubviews: [titleLabel, authorLabel], customSpacing: 8),
      starsStackView,
      bodyLabel
      ], spacing: 12)
    titleLabel.setContentCompressionResistancePriority(.init(0), for: .horizontal)
    authorLabel.textAlignment = .right
    addSubview(stackView)

    stackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 20, left: 20, bottom: 0, right: 20))
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
