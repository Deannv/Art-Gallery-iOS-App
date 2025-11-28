//
//  Artwork.swift
//  ArtGallery
//
//  Created by Kemas Deanova on 28/11/25.
//

import Foundation

struct Artwork: Identifiable, Codable, Equatable {
    let id: Int
    let title: String
    let artistTitle: String?
    let dateDisplay: String?
    let placeOfOrigin: String?
    let mediumDisplay: String?
    let dimensions: String?
    let description: String?
    let imageId: String?
    let thumbnail: Thumbnail?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case artistTitle = "artist_title"
        case dateDisplay = "date_display"
        case placeOfOrigin = "place_of_origin"
        case mediumDisplay = "medium_display"
        case dimensions
        case description
        case imageId = "image_id"
        case thumbnail
    }

    var artistSearchQuery: String {
        return artistTitle ?? ""
    }
}
