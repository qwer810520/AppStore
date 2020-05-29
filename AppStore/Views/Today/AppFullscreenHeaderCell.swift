//
//  AppFullscreenHeaderCell.swift
//  AppStore
//
//  Created by Min on 2020/5/26.
//  Copyright © 2020 Min. All rights reserved.
//

import UIKit

class AppFullscreenHeaderCell: UITableViewCell {

  let todayCell = TodayCell()



  // MARK: - Initialization

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    addSubview(todayCell)
    todayCell.fillSuperview()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
