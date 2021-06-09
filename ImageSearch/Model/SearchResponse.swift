//
//  SearchResponse.swift
//  ImageSearch
//
//  Created by Сергей Бабий on 13.05.2021.
//

import Foundation

// MARK: - Welcome
struct SearchResponse: Codable {
    var data: [Datum]
}

// MARK: - Datum
struct Datum: Codable {
    let type, id: String
    let url: String
    let slug, username, title, rating: String
    let sourceTLD: String
    let isSticker: Int
    let importDatetime: String
    let images: Images

    enum CodingKeys: String, CodingKey {
        case type, id, url, slug, username, title, rating
        case sourceTLD = "source_tld"
        case isSticker = "is_sticker"
        case importDatetime = "import_datetime"
        case images
    }
}

// MARK: - Images
struct Images: Codable {
    let original: Original
}

// MARK: - Original
struct Original: Codable {
    let height, width, size: String
    let url: String
    let webp: String
    let hash: String
}
