//
//  Extensions.swift
//  AppStore
//
//  Created by Min on 2020/5/20.
//  Copyright © 2020 Min. All rights reserved.
//

import UIKit

extension UILabel {
  convenience init(text: String, font: UIFont, numberOfLines: Int = 1) {
    self.init(frame: .zero)
    self.text = text
    self.font = font
    self.numberOfLines = numberOfLines
  }
}

extension UIImageView {
  convenience init(cornerRadius: CGFloat) {
    self.init(frame: .zero)
    self.layer.cornerRadius = cornerRadius
    self.clipsToBounds = true
    self.contentMode = .scaleAspectFill
  }
}

extension UIButton {
  convenience init(title: String) {
    self.init(type: .system)
    self.setTitle(title, for: .normal)
  }
}


