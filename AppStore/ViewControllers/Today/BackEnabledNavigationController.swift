//
//  BackEnabledNavigationController.swift
//  AppStore
//
//  Created by Min on 2020/5/27.
//  Copyright © 2020 Min. All rights reserved.
//

import UIKit

class BackEnabledNavigationController: UINavigationController {

  // MARK: - UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    interactivePopGestureRecognizer?.delegate = self
  }
}

  // MARK: - UIGestureRecognizerDelegate

extension BackEnabledNavigationController: UIGestureRecognizerDelegate {
  func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    return viewControllers.count > 1
  }
}
