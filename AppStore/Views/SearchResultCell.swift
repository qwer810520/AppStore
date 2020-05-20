//
//  SearchResultCell.swift
//  AppStore
//
//  Created by Min on 2020/5/17.
//  Copyright © 2020 Min. All rights reserved.
//

import UIKit

class SearchResultCell: UICollectionViewCell {

  var appResult: Result? {
    didSet {
      guard let appResult = appResult else { return }
      nameLabel.text = appResult.trackName
      categoryLabel.text = appResult.primaryGenreName
      ratingsLabel.text = "Rating: \(appResult.averageUserRating ?? 0)"

      let url = URL(string: appResult.artworkUrl100)
      appIconImageView.sd_setImage(with: url)

      screenshort1ImageView.sd_setImage(with: URL(string: appResult.screenshotUrls[0]))
      if appResult.screenshotUrls.count > 1 {
        screenshort2ImageView.sd_setImage(with: URL(string: appResult.screenshotUrls[1]))
      }

      if appResult.screenshotUrls.count > 2 {
        screenshort3ImageView.sd_setImage(with: URL(string: appResult.screenshotUrls[2]))
      }
    }
  }

  let appIconImageView: UIImageView = {
    let view = UIImageView()
    view.widthAnchor.constraint(equalToConstant: 64).isActive = true
    view.heightAnchor.constraint(equalToConstant: 64).isActive = true
    view.layer.cornerRadius = 12
    view.clipsToBounds = true
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

    let infoTopStackView = UIStackView(arrangedSubviews: [appIconImageView, VerticalStackView(arrangedSubviews: [nameLabel, categoryLabel, ratingsLabel]), getButton])
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
    imageView.layer.cornerRadius = 9
    imageView.clipsToBounds = true
    imageView.layer.borderWidth = 0.5
    imageView.layer.borderColor = UIColor(white: 0.5, alpha: 0.5).cgColor
    imageView.contentMode = .scaleAspectFill
    return imageView
  }
}


