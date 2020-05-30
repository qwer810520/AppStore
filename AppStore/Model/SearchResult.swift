//
//  SearchResult.swift
//  AppStore
//
//  Created by Min on 2020/5/19.
//  Copyright © 2020 Min. All rights reserved.
//

import Foundation

struct SearchResult: Decodable {
  let resultCount: Int
  let results: [Result]
}

struct Result: Decodable {
  let trackId: Int
  let trackName: String
  let primaryGenreName: String
  let averageUserRating: Float?
  var screenshotUrls: [String]?
  let artworkUrl100: String
  var formattedPrice: String?
  var description: String?
  var releaseNotes: String?
  var artistName: String?
  var collectionName: String?
}

