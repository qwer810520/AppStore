//
//  AppFullscreenController.swift
//  AppStore
//
//  Created by Min on 2020/5/26.
//  Copyright © 2020 Min. All rights reserved.
//

import UIKit

class AppFullscreenController: UITableViewController {

  // MARK: - UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.tableFooterView = UIView()
    tableView.separatorStyle = .none
  }
}

  // MARK: - UITableViewDelegate

extension AppFullscreenController {
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 450
  }
}

  // MARK: - UITableViewDataSource

extension AppFullscreenController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.row {
      case 0:
      let cell = UITableViewCell()
      let todayCell = TodayCell()
      cell.addSubview(todayCell)
      todayCell.centerInSuperview(size: .init(width: 250, height: 250))
      return cell
      default:
        let cell = AppFullscreenDescriptionCell()
        return cell
    }
  }
}


