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

    // MARK: - View state

    enum ViewState: Equatable {
        case idle
        case loading
        case loaded
        case empty
        case error(String)
    }

    // MARK: - Published state

    @Published var query: String = ""
    @Published private(set) var state: ViewState = .idle
    @Published private(set) var articles: [Article] = []

    // MARK: - Dependencies

    private let apiClient: APIClientProtocol

    // MARK: - Concurrency state

    private var debounceTask: Task<Void, Never>?
    private var fetchTask: Task<Void, Never>?

    // MARK: - Init / deinit

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    deinit {
        debounceTask?.cancel()
        fetchTask?.cancel()
    }

    // MARK: - Intent

    func loadInitialContent() async {
        await performFetch(.topHeadlines(country: "us"))
    }

    func queryChanged(_ newQuery: String) {
        debounceTask?.cancel()
        fetchTask?.cancel()

        let trimmed = newQuery.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmed.isEmpty else {
            debounceTask = Task { [weak self] in
                await self?.performFetch(.topHeadlines(country: "us"))
            }
            return
        }

        debounceTask = Task { [weak self] in
            do {
                try await Task.sleep(for: .milliseconds(300))
            } catch {
                return
            }
            await self?.performFetch(.search(query: trimmed))
        }
    }

    func refresh() async {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            await performFetch(.topHeadlines(country: "us"))
        } else {
            await performFetch(.search(query: trimmed))
        }
    }

    func dismissError() {
        if case .error = state {
            state = articles.isEmpty ? .empty : .loaded
        }
    }

    // MARK: - Core fetch

    private func performFetch(_ endpoint: NewsAPIEndpoint) async {
        fetchTask?.cancel()

        let task = Task { [weak self] in
            guard let self else { return }

            // Only show "loading" state if we don't already have articles.
            // Otherwise we'd blank the screen during a refresh.
            if self.articles.isEmpty {
                self.state = .loading
            }

            do {
                let response: NewsResponse = try await self.apiClient.request(endpoint: endpoint)

                // Critical: cancellation check before writing results.
                // Prevents stale results from clobbering newer ones.
                guard !Task.isCancelled else { return }

                self.articles = response.articles
                self.state = response.articles.isEmpty ? .empty : .loaded

            } catch is CancellationError {
                return
            } catch {
                guard !Task.isCancelled else { return }
                let message = (error as? LocalizedError)?.errorDescription
                    ?? "Something went wrong."
                self.state = .error(message)
            }
        }

        fetchTask = task
        await task.value
    }
}
