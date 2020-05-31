//
//  AppGroup.swift
//  AppStore
//
//  Created by Min on 2020/5/21.
//  Copyright © 2020 Min. All rights reserved.
//

import UIKit

struct AppGroup: Decodable {
  let feed: Feed
}

struct Feed: Decodable {
  let title: String
  let results: [FeedResult]
}

struct FeedResult: Decodable, Hashable {
  let id, name, artistName, artworkUrl100: String
}
