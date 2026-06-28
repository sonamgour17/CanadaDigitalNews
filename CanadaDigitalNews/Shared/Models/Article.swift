//  Article.swift
//  CanadaDigitalNews
//  Created by Sonam Gour on 14/05/26.

import Foundation

struct NewsResponse: Decodable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

struct Article: Decodable, Identifiable {
    let source: Source?
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: Date
    let content: String?

    // Using URL as the article ID because it is stable across API fetches.
    // This helps keep liked articles matched correctly after refresh.
    var id: String { url }
}

struct Source: Decodable {
    let id: String?
    let name: String?
}
