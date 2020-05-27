//
//  TodayItem.swift
//  AppStore
//
//  Created by Min on 2020/5/26.
//  Copyright © 2020 Min. All rights reserved.
//

import UIKit

struct TodayItem {
  let category: String
  let title: String
  let image: UIImage
  let description: String
  let backgroundColor: UIColor

  let cellType: CellType

  enum CellType: String {
    case single, mutltiple
  }
}
