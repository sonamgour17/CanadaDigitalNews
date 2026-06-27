//
//  ArticleDetailView.swift
//  CanadaDigitalNews
//
//  Created by Sonam Gour on 27/06/26.
//

import SwiftUI

struct ArticleDetailView: View {
    let articleID: String
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        VStack(spacing: 16) {
            Text("Article detail for ID:")
                .font(.headline)

            Text(articleID)
                .font(.title2)
                .foregroundStyle(.blue)

            Text("Module 4 replaces this with the real article view.")
                .foregroundStyle(.secondary)

            Button("Pop back") {
                router.pop()
            }
        }
        .padding()
        .navigationTitle("Article")
    }
}
