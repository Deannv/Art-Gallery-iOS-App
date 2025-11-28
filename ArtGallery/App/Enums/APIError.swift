//
//  APIError.swift
//  ArtGallery
//
//  Created by Kemas Deanova on 28/11/25.
//

enum APIError: Error {
    case invalidURL
    case serverError(Int)
    case decodeError
    case unknown(Error)
}
