//
//  HomeViewModel.swift
//  CanadaDigitalNews
//
//  Created by Sonam Gour on 14/05/26.
//

import Foundation
import Combine

/// View model for the Home tab — handles initial load, debounced search, and refresh.
@MainActor
final class HomeViewModel: ObservableObject {

    /// What the view should render.
    enum ViewState: Equatable {
        case idle
        case loading
        case loaded
        case empty
        case error(String)
    }

    // NewsAPI free tier returns reliable results for "us"; "ca" often returns empty.
    private static let defaultCountry = "us"

    // MARK: - Published state

    @Published var query: String = ""
    @Published private(set) var state: ViewState = .idle
    @Published private(set) var articles: [Article] = []

    // MARK: - Dependencies

    private let apiClient: APIClientProtocol

    // MARK: - Concurrency state

    // Tracked so a new keystroke can cancel the pending wait.
    private var debounceTask: Task<Void, Never>?

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    deinit {
        debounceTask?.cancel()
    }

    // MARK: - Intent

    /// Called once when the view first appears.
    func loadInitialContent() async {
        await fetchArticles(endpoint: .topHeadlines(country: Self.defaultCountry))
    }

    /// Called on every keystroke. Debounces, then searches or resets.
    func queryChanged(_ newQuery: String) {
        debounceTask?.cancel()

        let trimmed = newQuery.trimmingCharacters(in: .whitespacesAndNewlines)

        // Empty query → reset to top headlines.
        guard !trimmed.isEmpty else {
            debounceTask = Task { [weak self] in
                guard let self else { return }
                await self.fetchArticles(endpoint: .topHeadlines(country: Self.defaultCountry))
            }
            return
        }

        // Wait 300ms, then search. Cancelled if user types again.
        debounceTask = Task { [weak self] in
            do {
                try await Task.sleep(for: .milliseconds(300))
            } catch {
                return
            }
            guard let self else { return }
            await self.fetchArticles(endpoint: .search(query: trimmed))
        }
    }

    /// Pull-to-refresh.
    func refresh() async {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            await fetchArticles(endpoint: .topHeadlines(country: Self.defaultCountry))
        } else {
            await fetchArticles(endpoint: .search(query: trimmed))
        }
    }

    /// Dismisses error alert.
    func dismissError() {
        if case .error = state {
            state = articles.isEmpty ? .empty : .loaded
        }
    }

    // MARK: - Fetching

    /// Fetches articles for the given endpoint and updates view state.
    private func fetchArticles(endpoint: NewsAPIEndpoint) async {
        if articles.isEmpty {
            state = .loading
        }

        do {
            let response: NewsResponse = try await apiClient.request(endpoint: endpoint)
            articles = response.articles
            state = articles.isEmpty ? .empty : .loaded
        } catch {
            let message = (error as? LocalizedError)?.errorDescription
                ?? "Something went wrong."
            state = .error(message)
        }
    }
}
