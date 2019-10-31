//
//  JSONParser.swift
//  PodcastNotifications
//
//  Created by C4Q on 10/30/19.
//  Copyright © 2019 Iram Fattah. All rights reserved.
//

import Foundation
struct JSONParser {
    static func parsePodcastJSONFile() -> [Podcast] {
        let fileName = "podcasts"
        let type = "json"
        var podcasts: [Podcast] = []
        if let pathname = Bundle.main.path(forResource: fileName, ofType: type) {
            guard let jsonData = FileManager.default.contents(atPath: pathname) else {
                print("could not access json file")
                return [] }
            do {
                let decoder = JSONDecoder()
                let allResults = try decoder.decode(Results.self, from: jsonData)
                podcasts = allResults.results
            } catch {
                print("read json error: \(error)")
            }
        }
        return podcasts
    }
}
