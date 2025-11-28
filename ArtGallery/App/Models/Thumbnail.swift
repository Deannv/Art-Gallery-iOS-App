//
//  Thumbnail.swift
//  ArtGallery
//
//  Created by Kemas Deanova on 28/11/25.
//

import Foundation

struct Thumbnail: Codable, Equatable {
    let lqip: String?
    let altText: String?
    let width: Int?
    let height: Int?
    
    enum CodingKeys: String, CodingKey {
        case lqip
        case altText = "alt_text"
        case width
        case height
    }
}
