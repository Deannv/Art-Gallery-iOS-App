//
//  ArtworkRow.swift
//  ArtGallery
//
//  Created by Kemas Deanova on 28/11/25.
//

import SwiftUI

struct ArtworkRow: View {
    let artwork: Artwork
    let viewModel: ArtGalleryViewModel
    
    var body: some View {
        HStack(spacing: 16) {
            artworkImage
            
            VStack(alignment: .leading, spacing: 4) {
                Text(artwork.title)
                    .font(.headline)
                    .lineLimit(2)
                
                Text(artwork.artistTitle ?? "Unknown Artist")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(artwork.dateDisplay ?? "")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 8)
    }
    
    @ViewBuilder
    private var artworkImage: some View {
        if let uiImage = viewModel.decodeLqip(for: artwork) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                .clipped()
        } else {
            Image(systemName: "photo.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.gray)
                .frame(width: 80, height: 80)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                .clipped()
        }
    }
}
