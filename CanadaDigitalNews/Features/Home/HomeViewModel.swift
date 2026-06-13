//
//  HomeViewModel.swift
//  CanadaDigitalNews
//
//  Created by Sonam Gour on 14/05/26.
//

import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    
    @Published var articles: [Article] = []
    @Published var isLoading = false
    
    let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol = APIClient.shared) {
        self.apiClient = apiClient
    }
    
    func fetchNews() async {
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let response = try await apiClient.request(
                endpoint: NewsAPIEndpoint.topHeadlines(country: "us"),
                responseType: NewsResponse.self
            )
            
            print("✅ FULL RESPONSE:", response)
            print("📦 ARTICLES COUNT:", response.articles.count)
            print("📰 FIRST TITLE:", response.articles.first?.title ?? "nil")
            
            self.articles = response.articles
            
        } catch {
            print("❌ ERROR:", error)
        }
    }
}
