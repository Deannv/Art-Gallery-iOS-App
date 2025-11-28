//
//  FilterView.swift
//  ArtGallery
//
//  Created by Kemas Deanova on 28/11/25.
//

import SwiftUI

struct FilterView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var dateFilter: String
    let onApply: () -> Void
    
    private let years = [
        "No Filter", "1700", "1800", "1900", "1950", "2000", "2020"
    ]
    
    var body: some View {
        NavigationView {
            Form {
                Section("Filter by Completion Year (Artwork Created Before/In)") {
                    Picker("Year", selection: $dateFilter) {
                        ForEach(years, id: \.self) { year in
                            Text(year)
                        }
                    }
                    .pickerStyle(.wheel)
                }
            }
            .navigationTitle("Filter Artworks")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Apply") {
                        if dateFilter == "No Filter" { dateFilter = "" }
                        onApply()
                        dismiss()
                    }
                    .bold()
                }
            }
        }
    }
}
