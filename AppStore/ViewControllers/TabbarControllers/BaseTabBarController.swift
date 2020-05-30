//
//  BaseTabBarController.swift
//  AppStore
//
//  Created by Min on 2020/5/17.
//  Copyright © 2020 Min. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {

  // MARK: - UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()

    viewControllers = [
      createNavController(viewController: MusicController(), title: "Music", imageName: "music"),
      createNavController(viewController: TodayController(), title: "Today", imageName: "today_icon"),
      createNavController(viewController: AppsPageController(), title: "Apps", imageName: "apps"),
      createNavController(viewController: AppsSearchController(), title: "Search", imageName: "search")
    ]
  }

  // MARK: - Private Methods

  private func createNavController(viewController: UIViewController, title: String, imageName: String) -> UIViewController {
    let navController = UINavigationController(rootViewController: viewController)
    viewController.view.backgroundColor = .white
    viewController.navigationItem.title = title
    navController.tabBarItem.title = title
    navController.tabBarItem.image = UIImage(named: imageName)
    navController.navigationBar.prefersLargeTitles = true
    return navController
  }
}
