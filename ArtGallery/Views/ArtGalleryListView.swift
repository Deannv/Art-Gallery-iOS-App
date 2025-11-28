//
//  ArtGalleryListView.swift
//  ArtGallery
//
//  Created by Kemas Deanova on 28/11/25.
//

import SwiftUI

struct ArtGalleryListView: View {
    @EnvironmentObject var viewModel: ArtGalleryViewModel
    @State private var showingFilter = false

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading && viewModel.artworks.isEmpty {
                    ProgressView("Loading Artworks...")
                        .padding()
                } else if !viewModel.artworks.isEmpty {
                    listContent
                } else if let error = viewModel.errorMessage {
                    ErrorView(message: error, action: {
                        Task { await viewModel.loadArtworks(isNewSearch: true) }
                    })
                } else {
                    Spacer()
                    ContentUnavailableView(
                        "No Artworks Found",
                        systemImage: "photo.artframe",
                        description: Text("Try a different search term or filter.")
                    )
                    Spacer()
                }
                
                if viewModel.isLoadingNextPage {
                    ProgressView()
                        .padding()
                }
            }
            .navigationTitle("Art Gallery 🖼️")
            .searchable(text: $viewModel.searchText, prompt: "Search by title or artist")
            .onChange(of: viewModel.searchText) {
                Task { await viewModel.loadArtworks(isNewSearch: true) }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingFilter = true
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                    }
                }
            }
            .sheet(isPresented: $showingFilter) {
                FilterView(dateFilter: $viewModel.dateFilter) {
                    Task { await viewModel.loadArtworks(isNewSearch: true) }
                }
            }
        }
        .task {
            if viewModel.artworks.isEmpty {
                await viewModel.loadArtworks(isNewSearch: true)
            }
        }
    }
    
    private var listContent: some View {
        List {
            ForEach(viewModel.artworks) { artwork in
                NavigationLink(destination: ArtworkDetailView(artwork: artwork)) {
                    ArtworkRow(artwork: artwork, viewModel: viewModel)
                        .onAppear {
                            Task { await viewModel.fetchNextPage(artwork: artwork) }
                        }
                }
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    ArtGalleryListView()
}
