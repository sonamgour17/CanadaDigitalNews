//
//  HomeTabView.swift
//  CanadaDigitalNews
//
//  Created by Sonam Gour on 27/06/26.
//

import SwiftUI

struct MainTabView: View {

    @StateObject private var router = AppRouter()

    // Create one APIClient for the app's lifetime and inject it into view models.
    // @StateObject here owns the HomeViewModel's lifetime — survives view re-renders.
    @StateObject private var homeViewModel = HomeViewModel(apiClient: APIClient())

    var body: some View {
        TabView(selection: $router.selectedTab) {

            NavigationStack(path: $router.homePath) {
                HomeView(viewModel: homeViewModel)
                    .navigationDestination(for: AppRoute.self) { route in
                        destination(for: route)
                    }
            }
            .tabItem {
                Label(AppTab.home.title, systemImage: AppTab.home.systemImage)
            }
            .tag(AppTab.home)

            NavigationStack(path: $router.forYouPath) {
                ForYouView()
                    .navigationDestination(for: AppRoute.self) { route in
                        destination(for: route)
                    }
            }
            .tabItem {
                Label(AppTab.forYou.title, systemImage: AppTab.forYou.systemImage)
            }
            .tag(AppTab.forYou)
        }
        .environmentObject(router)
    }

    @ViewBuilder
    private func destination(for route: AppRoute) -> some View {
        switch route {
        case .articleDetail(let articleID):
            ArticleDetailView(articleID: articleID)
        }
    }
}

