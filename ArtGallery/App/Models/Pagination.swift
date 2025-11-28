//
//  Pagination.swift
//  ArtGallery
//
//  Created by Kemas Deanova on 28/11/25.
//

import Foundation

struct Pagination: Codable {
    let currentPage: Int
    let limit: Int
    let totalPages: Int
    let total: Int

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case limit
        case totalPages = "total_pages"
        case total
    }
}
