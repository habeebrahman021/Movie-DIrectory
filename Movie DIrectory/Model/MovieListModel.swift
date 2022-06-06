//
//  MovieListModel.swift
//  Movie DIrectory
//
//  Created by Habeeb Rahman on 30/05/22.
//

import Foundation
// MARK: - MovieList
struct MovieList: Codable {
    let page: Page
}

// MARK: - Page
struct Page: Codable {
    let title, totalContentItems, pageNum, pageSize: String
    let contentItems: ContentItems

    enum CodingKeys: String, CodingKey {
        case title
        case totalContentItems = "total-content-items"
        case pageNum = "page-num"
        case pageSize = "page-size"
        case contentItems = "content-items"
    }
}

// MARK: - ContentItems
struct ContentItems: Codable {
    let movies: [Movie]
    enum CodingKeys: String, CodingKey {
        case movies = "content"
    }
}

// MARK: - Content
struct Movie: Codable {
    let name: String
    let posterImage: String

    enum CodingKeys: String, CodingKey {
        case name
        case posterImage = "poster-image"
    }
}
