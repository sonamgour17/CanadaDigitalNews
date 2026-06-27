//
//  Article.swift
//  CanadaDigitalNews
//
//  Created by Sonam Gour on 14/05/26.
//

import Foundation

struct NewsResponse: Decodable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

struct Article: Decodable, Identifiable {
    let source: Source?
    let author: String?
    let title: String           // required — every article from NewsAPI has a title
    let description: String?
    let url: String             // required — used as the stable identifier
    let urlToImage: String?
    let publishedAt: Date       // decoded as Date via .iso8601 strategy in APIClient
    let content: String?

    // Identifier derived from the URL, which is stable across fetches.
    // Generating a UUID would break likes — the same article would have
    // different IDs on each fetch, so isLiked lookups would always fail.
    var id: String { url }
}

struct Source: Decodable {
    let id: String?
    let name: String?
}
