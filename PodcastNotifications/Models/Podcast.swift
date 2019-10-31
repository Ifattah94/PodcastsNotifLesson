//
//  Podcast.swift
//  PodcastNotifications
//
//  Created by C4Q on 10/30/19.
//  Copyright © 2019 Iram Fattah. All rights reserved.
//

import Foundation
struct Podcast: Codable {
    let collectionName: String
    let artworkUrl600: String
    let artistName: String
}

struct Results: Codable {
    let results: [Podcast]
}
