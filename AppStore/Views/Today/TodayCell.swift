//
//  TodayCell.swift
//  AppStore
//
//  Created by Min on 2020/5/26.
//  Copyright © 2020 Min. All rights reserved.
//

import UIKit

class TodayCell: UICollectionViewCell {

  let imageView = UIImageView(image: UIImage(named: "garden"))

  // MARK: - Initialization

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .white
    layer.cornerRadius = 16

    addSubview(imageView)
    imageView.contentMode = .scaleAspectFill
    imageView.centerInSuperview(size: CGSize(width: 250, height: 250))
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
