//
//  AppRouter.swift
//  CanadaDigitalNews
//
//  Created by Sonam Gour on 27/06/26.
//

import Foundation
import Combine

import Foundation

@MainActor
protocol AppRouting: AnyObject {
    var selectedTab: AppTab { get set }

    func push(_ route: AppRoute, on tab: AppTab?)
    func pop(on tab: AppTab?)
    func popToRoot(on tab: AppTab?)
    func switchTab(to tab: AppTab)
}

extension AppRouting {
    func push(_ route: AppRoute) { push(route, on: nil) }
    func pop() { pop(on: nil) }
    func popToRoot() { popToRoot(on: nil) }
}

@MainActor
final class AppRouter: ObservableObject, AppRouting {

    @Published var selectedTab: AppTab = .home
    @Published var homePath: [AppRoute] = []
    @Published var forYouPath: [AppRoute] = []

    func push(_ route: AppRoute, on tab: AppTab? = nil) {
        switch tab ?? selectedTab {
        case .home:   homePath.append(route)
        case .forYou: forYouPath.append(route)
        }
    }

    func pop(on tab: AppTab? = nil) {
        switch tab ?? selectedTab {
        case .home:
            guard !homePath.isEmpty else { return }
            homePath.removeLast()
        case .forYou:
            guard !forYouPath.isEmpty else { return }
            forYouPath.removeLast()
        }
    }

    func popToRoot(on tab: AppTab? = nil) {
        switch tab ?? selectedTab {
        case .home:   homePath.removeAll()
        case .forYou: forYouPath.removeAll()
        }
    }

    func switchTab(to tab: AppTab) {
        selectedTab = tab
    }
}
