//
//  DetailImageView.swift
//  ArtGallery
//
//  Created by Kemas Deanova on 28/11/25.
//

import SwiftUI

struct DetailImageView: View {
    let artwork: Artwork
    let viewModel: ArtGalleryViewModel
    @Binding var showingFullscreen: Bool
    
    var body: some View {
        let url = viewModel.imageURL(for: artwork)
        
        AsyncImage(url: url) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .onTapGesture {
                        showingFullscreen = true // Fullscreen user story
                    }
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(height: 300)
                    .overlay(ProgressView())
            }
        }
        .frame(maxWidth: .infinity)
    }
}
