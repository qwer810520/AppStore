//
//  AppFullscreenController.swift
//  AppStore
//
//  Created by Min on 2020/5/26.
//  Copyright © 2020 Min. All rights reserved.
//

import UIKit

class AppFullscreenController: UIViewController {

  var todayItem: TodayItem?
  var dismissHandler: (() -> Void)?

  let tableView = UITableView(frame: .zero, style: .plain)

  let closeButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(named: "close_button"), for: .normal)
    button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
    return button
  }()

  // MARK: - UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()

    view.addSubview(tableView)
    tableView.fillSuperview()
    tableView.tableFooterView = UIView()
    tableView.separatorStyle = .none
    tableView.allowsSelection = false
    tableView.contentInsetAdjustmentBehavior = .never
    tableView.delegate = self
    tableView.dataSource = self

    view.clipsToBounds = true

    setupCloseButton()

    var height: CGFloat = 0
    if #available(iOS 13, *) {
      height = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    } else {
      height = UIApplication.shared.statusBarFrame.height
    }
    tableView.contentInset = .init(top: 0, left: 0, bottom: height, right: 0)
  }

  // MARK: - Private Methods

  private func setupCloseButton() {
    view.addSubview(closeButton)
    closeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 12, left: 0, bottom: 0, right: 0), size: .init(width: 80, height: 40))
  }

  // MARK: - Action Methods

  @objc private func handleDismiss() {
    dismissHandler?()
  }
}

  // MARK: - UITableViewDelegate

extension AppFullscreenController: UITableViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    guard scrollView.contentOffset.y < 0 else { return }
    scrollView.isScrollEnabled = false
    scrollView.isScrollEnabled = true
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.row {
      case 0:
        return TodayController.cellSizeHeight
      default:
        return UITableView.automaticDimension
    }
  }
}

  // MARK: - UITableViewDataSource

extension AppFullscreenController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.row {
      case 0:
        let headerCell = AppFullscreenHeaderCell()
        headerCell.todayCell.todayItem = todayItem
        headerCell.todayCell.layer.cornerRadius = 0
        headerCell.clipsToBounds = true
        headerCell.todayCell.backgroundColor = nil
        return headerCell
      default:
        let cell = AppFullscreenDescriptionCell()
        return cell
    }
  }
}


