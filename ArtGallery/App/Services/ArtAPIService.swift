//
//  ArtAPIService.swift
//  ArtGallery
//
//  Created by Kemas Deanova on 28/11/25.
//

import Foundation

final class ArtAPIService {
    static let shared = ArtAPIService()
    private let baseURL = "https://api.artic.edu/api/v1/artworks"
    private let imageSize: String = "843,"

    private init() {}

    private func constructURL(page: Int, limit: Int, search: String?, dateFilter: String?) -> URL? {
            var path = baseURL
            let shouldSearch = !(search?.isEmpty ?? true) || !(dateFilter?.isEmpty ?? true)
            
            if shouldSearch {
                path = baseURL + "/search"
            }

            var components = URLComponents(string: path)

            var queryItems = [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "limit", value: "\(limit)"),
                URLQueryItem(name: "fields", value: "id,title,artist_title,date_display,image_id,thumbnail,config")
            ]

            if let search = search, !search.isEmpty {
                queryItems.append(URLQueryItem(name: "q", value: search))
            }

            if let dateFilter = dateFilter, !dateFilter.isEmpty {
                 let yearQuery = "publication_history_date_end:[* TO \(dateFilter)]"
                 queryItems.append(URLQueryItem(name: "query", value: yearQuery))
            }
            
            components?.queryItems = queryItems
            return components?.url
        }
    
    func fetchArtworks(page: Int = 1, limit: Int = 20, search: String? = nil, dateFilter: String? = nil) async throws -> (artworks: [Artwork], pagination: Pagination?, config: APIConfig) {
        guard let url = constructURL(page: page, limit: limit, search: search, dateFilter: dateFilter) else {
            throw APIError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.unknown(URLError(.badServerResponse))
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.serverError(httpResponse.statusCode)
        }

        do {
            let decodedResponse = try JSONDecoder().decode(APIResponse<[Artwork]>.self, from: data)
            return (decodedResponse.data, decodedResponse.pagination, decodedResponse.config)
        } catch {
            print("Decoding Error: \(error)")
            throw APIError.decodeError
        }
    }
    
    func fetchArtworkDetail(id: Int) async throws -> Artwork {
        let fields = "id,title,artist_title,date_display,place_of_origin,medium_display,dimensions,description,image_id"
        let detailURL = "\(baseURL)/\(id)?fields=\(fields)"
        
        guard let url = URL(string: detailURL) else {
            throw APIError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw APIError.serverError((response as? HTTPURLResponse)?.statusCode ?? -1)
        }

        do {
            let decodedResponse = try JSONDecoder().decode(APIResponse<Artwork>.self, from: data)
            return decodedResponse.data
        } catch {
            throw APIError.decodeError
        }
    }

    func getImageURL(iiifUrl: String?, imageId: String?) -> URL? {
        guard let iiifUrl = iiifUrl,
              let imageId = imageId,
              !iiifUrl.isEmpty,
              !imageId.isEmpty else {
            return nil
        }
        
        let urlString = "\(iiifUrl)/\(imageId)/full/\(imageSize),/0/default.jpg"
        return URL(string: urlString)
    }
}
