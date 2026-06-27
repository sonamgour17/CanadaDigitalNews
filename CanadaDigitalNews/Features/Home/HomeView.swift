//
//  HomeView.swift
//  CanadaDigitalNews
//
//  Created by Sonam Gour on 13/05/26.
//

// Features/Home/HomeView.swift

import SwiftUI

// NewsApp/Features/Home/HomeView.swift

import SwiftUI

struct HomeView: View {

    @ObservedObject var viewModel: HomeViewModel
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        content
            .navigationTitle("Top Stories")
            .searchable(text: $viewModel.query, prompt: "Search news")
            .onChange(of: viewModel.query) { _, newValue in
                viewModel.queryChanged(newValue)
            }
            .task {
                await viewModel.loadInitialContent()
            }
            .refreshable {
                await viewModel.refresh()
            }
            .alert(
                "Error",
                isPresented: errorAlertBinding,
                actions: {
                    Button("Cancel", role: .cancel) {
                        viewModel.dismissError()
                    }
                    Button("Try again") {
                        Task { await viewModel.refresh() }
                    }
                },
                message: {
                    if case .error(let message) = viewModel.state {
                        Text(message)
                    }
                }
            )
    }

    private var errorAlertBinding: Binding<Bool> {
        Binding(
            get: {
                if case .error = viewModel.state { return true }
                return false
            },
            set: { isPresented in
                if !isPresented {
                    viewModel.dismissError()
                }
            }
        )
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading where viewModel.articles.isEmpty:
            ProgressView()
                .scaleEffect(1.4)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .empty:
            ContentUnavailableView(
                "No articles",
                systemImage: "newspaper",
                description: Text("Try a different search, or pull to refresh.")
            )

        case .loaded, .loading, .error:
            // .loaded and .loading-with-data both show the list.
            // .error keeps showing the list underneath the alert.
            articleList
        }
    }

    private var articleList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.articles) { article in
                    Button {
                        router.push(.articleDetail(articleID: article.id))
                    } label: {
                        ArticleRow(article: article)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
    }
}
