//
//  MusicLoadingFooter.swift
//  AppStore
//
//  Created by Min on 2020/5/30.
//  Copyright © 2020 Min. All rights reserved.
//

import UIKit

class MusicLoadingFooter: UICollectionReusableView {

  // MARK: - Initialization

  override init(frame: CGRect) {
    super.init(frame: frame)
    let aiv = UIActivityIndicatorView(style: .medium)
    aiv.color = .darkGray
    aiv.startAnimating()

    let label = UILabel(text: "Loading more...", font: .systemFont(ofSize: 16))
    label.textAlignment = .center

    let stackView = VerticalStackView(arrangedSubviews: [aiv, label], spacing: 8)
    addSubview(stackView)
    stackView.centerInSuperview(size: .init(width: 200, height: 0))
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
