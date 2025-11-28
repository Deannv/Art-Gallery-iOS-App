//
//  APIConfig.swift
//  ArtGallery
//
//  Created by Kemas Deanova on 28/11/25.
//

import Foundation

struct APIConfig: Codable {
    let iiifUrl: String?

    enum CodingKeys: String, CodingKey {
        case iiifUrl = "iiif_url"
    }
}
