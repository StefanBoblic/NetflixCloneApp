//
//  YouTubeSearchResponse.swift
//  NetflixApp
//
//  Created by Stefan Boblic on 14.12.2022.
//

import Foundation

struct YouTubeSearchResponse: Codable {
    let items: [VideoElement]
}

struct VideoElement: Codable {
    let id: IdVideoElement
}

struct IdVideoElement: Codable {
    let kind: String
    let videoId: String
}
