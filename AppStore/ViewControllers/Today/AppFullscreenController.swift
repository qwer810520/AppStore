//
//  AppFullscreenController.swift
//  AppStore
//
//  Created by Min on 2020/5/26.
//  Copyright © 2020 Min. All rights reserved.
//

import UIKit

class AppFullscreenController: UITableViewController {

  var todayItem: TodayItem?
  var dismissHandler: (() -> Void)?

  // MARK: - UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.tableFooterView = UIView()
    tableView.separatorStyle = .none
    tableView.allowsSelection = false
    tableView.contentInsetAdjustmentBehavior = .never
    var height: CGFloat = 0
    if #available(iOS 13, *) {
      height = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    } else {
      height = UIApplication.shared.statusBarFrame.height
    }
    tableView.contentInset = .init(top: 0, left: 0, bottom: height, right: 0)
  }

  // MARK: - Action Methods

  @objc private func handleDismiss() {
    dismissHandler?()
  }
}

  // MARK: - UITableViewDelegate

extension AppFullscreenController {
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.row {
      case 0:
        return 450
      default:
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
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
      let headerCell = AppFullscreenHeaderCell()
      headerCell.closeButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
      headerCell.todayCell.todayItem = todayItem
      headerCell.todayCell.layer.cornerRadius = 0
      return headerCell
      default:
        let cell = AppFullscreenDescriptionCell()
        return cell
    }
  }
}


