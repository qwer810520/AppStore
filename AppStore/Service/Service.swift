//
//  Service.swift
//  AppStore
//
//  Created by Min on 2020/5/19.
//  Copyright © 2020 Min. All rights reserved.
//

import UIKit

class Service {

  static let shared = Service()

  func fetchApps(complection: @escaping ([Result], Error?) -> Void) {
    let urlString = "https://itunes.apple.com/search?term=instagram&entity=software"

    guard let url = URL(string: urlString) else { return }

    URLSession.shared.dataTask(with: url) { (data, response, error) in
      if let error = error {
        print("Failed to fetch apps: ", error)
        complection([], error)
        return
      }

      guard let data = data else { return }

      do {
        let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
        complection(searchResult.results, nil)
      } catch let jsonErr {
        print("Failed to decode json: ", jsonErr)
        complection([], jsonErr)
      }

    }.resume()
  }
}
