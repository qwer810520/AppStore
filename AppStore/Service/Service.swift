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

  func fetchApps(searchTerm: String, completion: @escaping ([Result], Error?) -> Void) {
    let urlString = "https://itunes.apple.com/search?term=\(searchTerm)&entity=software"

    guard let url = URL(string: urlString) else { return }

    URLSession.shared.dataTask(with: url) { (data, response, error) in
      if let error = error {
        print("Failed to fetch apps: ", error)
        completion([], error)
        return
      }

      guard let data = data else { return }

      do {
        let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
        completion(searchResult.results, nil)
      } catch let jsonErr {
        print("Failed to decode json: ", jsonErr)
        completion([], jsonErr)
      }

    }.resume()
  }

  func fetchTopGrossing(completion: @escaping (AppGroup?, Error?) -> Void) {
     let url = "https://rss.itunes.apple.com/api/v1/us/ios-apps/top-grossing/all/50/explicit.json"
    fetchAppGroup(urlString: url, completion: completion)
  }

  func fetchGames(completion: @escaping (AppGroup?, Error?) -> Void) {
    fetchAppGroup(urlString: "https://rss.itunes.apple.com/api/v1/us/ios-apps/new-apps-we-love/all/50/explicit.json", completion: completion)
  }

  func fetchAppGroup(urlString: String, completion: @escaping (AppGroup?, Error?) -> Void) {
    guard let url = URL(string: urlString) else { return }
    URLSession.shared.dataTask(with: url) { (data, response, error) in
      if let error = error {
        completion(nil, error)
        return
      }

      guard let data = data else { return }

      do {
        let appGroup = try JSONDecoder().decode(AppGroup.self, from: data)
        completion(appGroup, nil)
      } catch {
        completion(nil, error)
      }
    }.resume()
  }

  func fetchSocialApps(completion: @escaping ([SocialApp]?, Error?) -> Void) {
    let urlString = "https://api.letsbuildthatapp.com/appstore/social"

    guard let url = URL(string: urlString) else { return }
       URLSession.shared.dataTask(with: url) { (data, response, error) in
         if let error = error {
           completion(nil, error)
           return
         }

         guard let data = data else { return }

         do {
           let objects = try JSONDecoder().decode([SocialApp].self, from: data)
           completion(objects, nil)
         } catch {
           completion(nil, error)
         }
       }.resume()
  }
}
