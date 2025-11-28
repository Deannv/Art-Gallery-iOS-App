//
//  ArtGalleryApp.swift
//  ArtGallery
//
//  Created by Kemas Deanova on 28/11/25.
//

import SwiftUI

@main
struct ArtGalleryApp: App {
    @StateObject var viewModel = ArtGalleryViewModel()
    
    var body: some Scene {
        WindowGroup {
            ArtGalleryListView()
                .environmentObject(viewModel)
        }
    }
}
