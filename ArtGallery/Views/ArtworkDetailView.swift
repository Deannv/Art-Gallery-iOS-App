//
//  ArtworkDetailView.swift
//  ArtGallery
//
//  Created by Kemas Deanova on 28/11/25.
//

import SwiftUI

struct ArtworkDetailView: View {
    @EnvironmentObject var viewModel: ArtGalleryViewModel
    let artwork: Artwork
    
    @State private var detailArtwork: Artwork?
    @State private var relatedArtworks: [Artwork] = []
    @State private var isLoadingDetail = false
    @State private var showingImageFullscreen = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                DetailImageView(artwork: artwork, viewModel: viewModel, showingFullscreen: $showingImageFullscreen)
                
                Group {
                    let displayArtwork = detailArtwork ?? artwork
                    
                    Text(displayArtwork.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        detailRow(label: "Artist", value: displayArtwork.artistTitle ?? "Unknown")
                        detailRow(label: "Date", value: displayArtwork.dateDisplay ?? "N/A")
                        
                        Divider()
                        
                        detailRow(label: "Origin", value: displayArtwork.placeOfOrigin ?? "N/A")
                        detailRow(label: "Medium", value: displayArtwork.mediumDisplay ?? "N/A")
                        detailRow(label: "Dimensions", value: displayArtwork.dimensions ?? "N/A")
                    }
                    
                    if let description = displayArtwork.description?.htmlStripped, !description.isEmpty {
                        Text("**Description**")
                            .font(.title3)
                        Text(description)
                            .font(.body)
                    }
                }
                .padding(.horizontal)
                
                if !relatedArtworks.isEmpty {
                    relatedArtworksSection
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingImageFullscreen) {
            FullscreenImageView(
                url: viewModel.imageURL(for: artwork)
            )
        }
        .task {
            await fetchDetailAndRelated()
        }
    }
    
    private func detailRow(label: String, value: String) -> some View {
        HStack(alignment: .top) {
            Text("\(label):")
                .font(.headline)
                .frame(width: 90, alignment: .leading)
            Text(value)
                .font(.body)
                .multilineTextAlignment(.leading)
        }
    }
    
    private var relatedArtworksSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("More by \(detailArtwork?.artistTitle ?? "This Artist")")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(relatedArtworks.filter { $0.id != artwork.id }) { related in
                        NavigationLink(destination: ArtworkDetailView(artwork: related)) {
                            RelatedArtworkCard(artwork: related, viewModel: viewModel)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private func fetchDetailAndRelated() async {
        isLoadingDetail = true
        do {
            let detail = try await ArtAPIService.shared.fetchArtworkDetail(id: artwork.id)
            detailArtwork = detail
            relatedArtworks = await viewModel.fetchRelatedArtworks(artistTitle: detail.artistTitle)
        } catch {
            print("Failed to load detail: \(error)")
        }
        isLoadingDetail = false
    }
}
