//
//  RelatedArtworkCard.swift
//  ArtGallery
//
//  Created by Kemas Deanova on 28/11/25.
//

import SwiftUI

struct RelatedArtworkCard: View {
    let artwork: Artwork
    let viewModel: ArtGalleryViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            image
            Text(artwork.title)
                .font(.caption)
                .lineLimit(2)
                .foregroundColor(.primary)
            Text(artwork.dateDisplay ?? "")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(width: 120)
    }
    
    private var image: some View {
        let url = viewModel.imageURL(for: artwork)
        return AsyncImage(url: url) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
            }
        }
        .frame(width: 120, height: 120)
        .clipped()
        .cornerRadius(6)
    }
}
