//
//  VerticalStackView.swift
//  AppStore
//
//  Created by Min on 2020/5/18.
//  Copyright © 2020 Min. All rights reserved.
//

import UIKit

class VerticalStackView: UIStackView {

  // MARK: - Initialization

  init(arrangedSubviews: [UIView], spacing: CGFloat = 0) {
    super.init(frame: .zero)
    arrangedSubviews.forEach { addArrangedSubview($0) }
    self.spacing = spacing
    self.axis = .vertical
  }

  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
