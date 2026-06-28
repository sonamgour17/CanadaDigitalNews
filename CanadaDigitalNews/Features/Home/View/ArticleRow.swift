//
//  ArticleRow.swift
//  CanadaDigitalNews
//
//  Created by Sonam Gour on 27/06/26.
//

import SwiftUI

// NewsApp/Features/Home/ArticleRow.swift

import SwiftUI

struct ArticleRow: View {
    let article: Article

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            // Image
            if let imageURL = article.urlToImage.flatMap(URL.init(string:)) {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .empty:
                        Color.gray.opacity(0.15)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure:
                        Color.gray.opacity(0.15)
                    @unknown default:
                        Color.gray.opacity(0.15)
                    }
                }
                .frame(height: 200)
                .frame(maxWidth: .infinity)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            // Title
            Text(article.title)
                .font(.headline)
                .foregroundStyle(.primary)
                .lineLimit(3)
                .multilineTextAlignment(.leading)

            // Source + date footer
            HStack {
                if let sourceName = article.source?.name {
                    Text(sourceName)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text(article.publishedAt.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(12)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
