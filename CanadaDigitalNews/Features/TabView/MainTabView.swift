//
//  HomeTabView.swift
//  CanadaDigitalNews
//
//  Created by Sonam Gour on 27/06/26.
//

import SwiftUI

struct MainTabView: View {

    @StateObject private var router = AppRouter()

    var body: some View {
        TabView(selection: $router.selectedTab) {

            NavigationStack(path: $router.homePath) {
                HomeView()
                    .navigationDestination(for: AppRoute.self) { route in
                        destination(for: route)
                    }
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            .tag(AppTab.home)

            NavigationStack(path: $router.forYouPath) {
                ForYouView()
                    .navigationDestination(for: AppRoute.self) { route in
                        destination(for: route)
                    }
            }
            .tabItem {
                Label("For You", systemImage: "star.fill")
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
