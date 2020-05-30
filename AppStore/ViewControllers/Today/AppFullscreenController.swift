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
  let floatingContainerView = UIView()

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

    let height: CGFloat = getStatusBarHeight()
    tableView.contentInset = .init(top: 0, left: 0, bottom: height, right: 0)

    setupFloatingContols()
  }

  // MARK: - Private Methods

  private func setupCloseButton() {
    view.addSubview(closeButton)
    closeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 12, left: 0, bottom: 0, right: 0), size: .init(width: 80, height: 40))
  }

  private func setupFloatingContols() {
    floatingContainerView.clipsToBounds = true
    floatingContainerView.layer.cornerRadius = 16
    view.addSubview(floatingContainerView)

    floatingContainerView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 16, bottom: -90, right: 16), size: .init(width: 0, height: 90))

    let blurVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    floatingContainerView.addSubview(blurVisualEffectView)
    blurVisualEffectView.fillSuperview()

    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))

    // add our subviews

    let imageView = UIImageView(cornerRadius: 16)
    imageView.image = todayItem?.image

    imageView.constrainHeight(constant: 68)
    imageView.constrainWidth(constant: 68)

    let getButton = UIButton(title: "Get")
    getButton.setTitleColor(.white, for: .normal)
    getButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
    getButton.backgroundColor = .darkGray
    getButton.layer.cornerRadius = 16
    getButton.constrainWidth(constant: 80)
    getButton.constrainHeight(constant: 32)

    let stackView = UIStackView(arrangedSubviews: [
      imageView,
      VerticalStackView(arrangedSubviews: [
        UILabel(text: "Life Hack", font: .boldSystemFont(ofSize: 18)),
        UILabel(text: "Utilizing your Time", font: .systemFont(ofSize: 16))
      ], spacing: 4),
      getButton
    ], customSpacing: 16)

    floatingContainerView.addSubview(stackView)
    stackView.fillSuperview(padding: .init(top: 0, left: 16, bottom: 0, right: 16))
    stackView.alignment = .center
  }

  private func getStatusBarHeight() -> CGFloat {
    return UIApplication.shared.statusBarFrame.height
//    if #available(iOS 13, *) {
//      return view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
//    } else {
//      return UIApplication.shared.statusBarFrame.height
//    }
  }

  // MARK: - Action Methods

  @objc private func handleDismiss() {
    dismissHandler?()
  }

  @objc private func handleTap() {
    UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
      self.floatingContainerView.transform = .init(translationX: 0, y: -90)
    })
  }
}

  // MARK: - UITableViewDelegate

extension AppFullscreenController: UITableViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView.contentOffset.y < 0 {
      scrollView.isScrollEnabled = false
      scrollView.isScrollEnabled = true
    }

    let translatuionY = -90 - self.getStatusBarHeight()
    let transform = scrollView.contentOffset.y > 100 ? CGAffineTransform(translationX: 0, y: translatuionY) : .identity

    UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
      self.floatingContainerView.transform = transform
    })
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


