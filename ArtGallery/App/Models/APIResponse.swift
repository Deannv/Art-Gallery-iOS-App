//
//  APIResponse.swift
//  ArtGallery
//
//  Created by Kemas Deanova on 28/11/25.
//

import Foundation

struct APIResponse<T: Codable>: Codable {
    let data: T
    let pagination: Pagination?
    let config: APIConfig
}
