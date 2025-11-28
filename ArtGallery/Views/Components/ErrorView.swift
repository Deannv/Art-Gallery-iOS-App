//
//  ErrorView.swift
//  ArtGallery
//
//  Created by Kemas Deanova on 28/11/25.
//

import SwiftUI

struct ErrorView: View {
    let message: String
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.largeTitle)
                .foregroundColor(.red)
            Text("Error")
                .font(.title)
            Text(message)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            Button("Retry") {
                action()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
