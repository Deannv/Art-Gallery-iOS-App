//
//  FullscreenImageView.swift
//  ArtGallery
//
//  Created by Kemas Deanova on 28/11/25.
//

import SwiftUI

struct FullscreenImageView: View {
    @Environment(\.dismiss) var dismiss
    let url: URL?
    @State private var statusMessage: String?
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            if let url = url {
                AsyncImage(url: url) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .gesture(
                                TapGesture(count: 2).onEnded {
                                    dismiss()
                                }
                            )
                            .navigationBarHidden(true)
                    } else if phase.error != nil {
                        Text("Failed to load image.")
                            .foregroundColor(.white)
                    } else {
                        ProgressView()
                    }
                }
            } else {
                Text("Image not available.")
                    .foregroundColor(.white)
            }
            
            VStack {
                HStack {
                    Spacer()
                    Button { dismiss() } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .padding(.top, 40)
                            .padding(.trailing, 20)
                    }
                }
                Spacer()
            }
            
            // Status Message Overlay
            if let status = statusMessage {
                VStack {
                    Spacer()
                    Text(status)
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .transition(.opacity)
                        .onAppear {
                            // Dismiss message after 2 seconds
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation { statusMessage = nil }
                            }
                        }
                    Spacer().frame(height: 50)
                }
            }
        }
        .overlay(downloadButton, alignment: .bottom)
    }
    
    private var downloadButton: some View {
        Button {
            Task { await saveImage() }
        } label: {
            Label("Download to Gallery", systemImage: "square.and.arrow.down")
                .font(.headline)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .padding(.bottom, 50)
    }
    
    private func saveImage() async {
        guard let url = url else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let uiImage = UIImage(data: data) else {
                throw NSError(domain: "ImageError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid image data."])
            }
            
            UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
            withAnimation { statusMessage = "Image Saved to Gallery! ✅" }
        } catch {
            withAnimation { statusMessage = "Download Failed ❌" }
            print("Download and save error: \(error)")
        }
    }
}
