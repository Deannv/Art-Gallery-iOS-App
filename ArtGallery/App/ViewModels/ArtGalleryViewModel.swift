//
//  ArtGalleryViewModel.swift
//  ArtGallery
//
//  Created by Kemas Deanova on 28/11/25.
//

import Foundation
internal import Combine
import UIKit

@MainActor
final class ArtGalleryViewModel: ObservableObject {
    @Published var artworks: [Artwork] = []
    @Published var isLoading = false
    @Published var isLoadingNextPage = false
    @Published var errorMessage: String?
    @Published var searchText = ""
    @Published var dateFilter = ""
    
    private var currentPage = 1
    private var totalPages = 1
    private var iiifUrl: String?
    private var currentSearchText: String?
    private var currentFilter: String?

    func loadArtworks(isNewSearch: Bool = false) async {
        if isNewSearch {
            currentPage = 1
            artworks = []
            currentSearchText = searchText
            currentFilter = dateFilter
            isLoading = true
        } else if currentPage > totalPages {
            return
        } else {
            isLoadingNextPage = true
        }
        
        errorMessage = nil

        do {
            let result = try await ArtAPIService.shared.fetchArtworks(
                page: currentPage,
                limit: 20,
                search: currentSearchText,
                dateFilter: currentFilter
            )
            
            if iiifUrl == nil, let newUrl = result.config.iiifUrl {
                 iiifUrl = newUrl
            }
            totalPages = result.pagination?.totalPages ?? 1
            
            if isNewSearch {
                artworks = result.artworks.filter { $0.imageId != nil }
            } else {
                artworks.append(contentsOf: result.artworks.filter { $0.imageId != nil })
            }
            
            currentPage += 1

        } catch {
            handleError(error)
        }
        
        isLoading = false
        isLoadingNextPage = false
    }

    func shouldLoadMore(artwork: Artwork) -> Bool {
        guard let index = artworks.firstIndex(where: { $0.id == artwork.id }) else { return false }
        return index == artworks.count - 5
    }

    func fetchNextPage(artwork: Artwork) async {
        if shouldLoadMore(artwork: artwork) && !isLoading && !isLoadingNextPage {
            await loadArtworks()
        }
    }

    func fetchRelatedArtworks(artistTitle: String?) async -> [Artwork] {
        guard let artistTitle = artistTitle, !artistTitle.isEmpty else { return [] }
        
        do {
            let result = try await ArtAPIService.shared.fetchArtworks(
                page: 1,
                limit: 10,
                search: artistTitle,
                dateFilter: nil
            )
            return result.artworks.filter { $0.imageId != nil }
        } catch {
            print("Failed to load related works: \(error)")
            return []
        }
    }
    
    func decodeLqip(for artwork: Artwork) -> UIImage? {
        guard let lqipString = artwork.thumbnail?.lqip else {
            return nil
        }
        return lqipString.toUIImage()
    }
    
    func imageURL(for artwork: Artwork) -> URL? {
        return ArtAPIService.shared.getImageURL(iiifUrl: iiifUrl, imageId: artwork.imageId)
    }

    private func handleError(_ error: Error) {
        if let apiError = error as? APIError {
            switch apiError {
            case .invalidURL:
                errorMessage = "An internal configuration error occurred."
            case .serverError(let code):
                errorMessage = "Server error \(code). Please try again."
            case .decodeError:
                errorMessage = "Data format is invalid. Cannot display content."
            case .unknown:
                errorMessage = "An unexpected error occurred. Check your connection."
            }
        } else {
            errorMessage = "An unknown error occurred."
        }
    }
}
