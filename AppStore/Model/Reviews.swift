//
//  Reviews.swift
//  AppStore
//
//  Created by Min on 2020/5/25.
//  Copyright © 2020 Min. All rights reserved.
//

import UIKit

struct Reviews: Decodable {
  let feed: ReviewFeed
}

struct ReviewFeed: Decodable {
  let entry: [Entry]
}

struct Entry: Decodable {
  let author: Author
  let title: Label
  let content: Label
  let rating: Label

  enum CodingKeys: String, CodingKey {
    case author, title, content
    case rating = "im:rating"
  }

  
}

struct Author: Decodable {
  let uri: Label
  let name: Label
  let label: String
}

struct Label: Decodable {
  let label: String
}
