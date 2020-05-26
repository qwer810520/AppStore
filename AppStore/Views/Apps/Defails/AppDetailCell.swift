//
//  AppDetailCell.swift
//  AppStore
//
//  Created by Min on 2020/5/25.
//  Copyright © 2020 Min. All rights reserved.
//

import UIKit

class AppDetailCell: UICollectionViewCell {

  var app: Result? {
    didSet {
      guard let app = app else { return }
      nameLabel.text = app.trackName
      releaseNotesLabel.text = app.releaseNotes
      appIconImageView.sd_setImage(with: URL(string: app.artworkUrl100))
      priceButton.setTitle(app.formattedPrice, for: .normal)
    }
  }

  let appIconImageView: UIImageView = {
    return UIImageView(cornerRadius: 16)
  }()

  let nameLabel: UILabel = {
    return UILabel(text: "App Name", font: .boldSystemFont(ofSize: 24), numberOfLines: 2)
  }()

  let priceButton: UIButton = {
    return UIButton(title: "$4.99")
  }()

  let whatNewLabel: UILabel = {
    return UILabel(text: "What's New", font: .boldSystemFont(ofSize: 20))
  }()

  let releaseNotesLabel: UILabel = {
    return UILabel(text: "Release Notes", font: .systemFont(ofSize: 18), numberOfLines: 0)
  }()

  // MARK: - Initialization

  override init(frame: CGRect) {
    super.init(frame: frame)

    appIconImageView.constrainWidth(constant: 140)
    appIconImageView.constrainHeight(constant: 140)

    priceButton.backgroundColor = #colorLiteral(red: 0.2093189657, green: 0.4672276378, blue: 0.9736761451, alpha: 1)
    priceButton.constrainHeight(constant: 32)
    priceButton.constrainWidth(constant: 80)
    priceButton.layer.cornerRadius = 32 / 2
    priceButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
    priceButton.setTitleColor(.white, for: .normal)

    let stackView = VerticalStackView(
      arrangedSubviews: [
        UIStackView(
          arrangedSubviews: [
            appIconImageView,
            VerticalStackView(
              arrangedSubviews: [
                nameLabel,
                UIStackView(arrangedSubviews: [priceButton, UIView()]),
                UIView()
              ],
              spacing: 12)],
          customSpacing: 20),
        whatNewLabel,
        releaseNotesLabel],
      spacing: 16)
    addSubview(stackView)
    stackView.fillSuperview(padding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

extension UIStackView {
  convenience init(arrangedSubviews: [UIView], customSpacing: CGFloat = 0) {
    self.init(arrangedSubviews: arrangedSubviews)
    self.spacing = customSpacing
  }
}
