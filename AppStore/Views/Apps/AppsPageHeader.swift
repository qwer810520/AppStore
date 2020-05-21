//
//  AppsPageHeader.swift
//  AppStore
//
//  Created by Min on 2020/5/20.
//  Copyright © 2020 Min. All rights reserved.
//

import UIKit

class AppsPageHeader: UICollectionReusableView {

  let appHeaderHorizontalController = AppsHeaderHorizontalController()

  // MARK: - Initialization

  override init(frame: CGRect) {
    super.init(frame: frame)

    addSubview(appHeaderHorizontalController.view)
    appHeaderHorizontalController.view.fillSuperview()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
