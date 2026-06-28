//
//  AppRouter.swift
//  CanadaDigitalNews
//
//  The single navigation coordinator for the whole app.
//  Owns the currently-selected tab and the navigation path for each tab.
//

import Foundation
import Combine

@MainActor
protocol AppRouting: AnyObject {
    var selectedTab: AppTab { get set }

    func push(_ route: AppRoute, on tab: AppTab?)
    func pop(on tab: AppTab?)
    func popToRoot(on tab: AppTab?)
    func switchTab(to tab: AppTab)
}

/// Convenience overloads so callers can omit `on: nil` when they
/// want to operate on the currently-selected tab (the common case).
extension AppRouting {
    
    func push(_ route: AppRoute) {
        push(route, on: nil)
    }
    
    func pop() {
        pop(on: nil)
    }
    
    func popToRoot() {
        popToRoot(on: nil)
    }
}

// MARK: - Concrete router

@MainActor
final class AppRouter: ObservableObject, AppRouting {

    // Per-tab navigation paths. Each tab maintains its own back stack
    // so switching tabs doesn't lose navigation state — standard iOS
    // behavior (Apple's own apps work this way).
    @Published var selectedTab: AppTab = .home
    @Published var homePath: [AppRoute] = []
    @Published var forYouPath: [AppRoute] = []

    // MARK: - Push / Pop

    /// Appends a route to the specified tab's path, or the current
    /// tab's path if `tab` is nil.
    func push(_ route: AppRoute, on tab: AppTab? = nil) {
        
        switch tab ?? selectedTab {
        case .home:
            homePath.append(route)
            
        case .forYou:
            forYouPath.append(route)
        }
    }

    /// Removes the last route from the specified tab's path.
    /// No-op if the path is already empty.
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

    /// Clears the specified tab's path, returning to its root view.
    func popToRoot(on tab: AppTab? = nil) {
        
        switch tab ?? selectedTab {
            
        case .home:
            homePath.removeAll()
            
        case .forYou:
            forYouPath.removeAll()
        }
    }

    // MARK: - Tab switching

    func switchTab(to tab: AppTab) {
        selectedTab = tab
    }
}
