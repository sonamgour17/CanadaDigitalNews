//
//  AppTab.swift
//  CanadaDigitalNews
//
//  Created by Sonam Gour on 27/06/26.
//

import Foundation

/// Defines the main tabs available in the app.
enum AppTab: Hashable {
    case home
    case forYou
    
    var title: String {
        switch self {
        case .home:
            return AppConstants.Strings.Tab.home
        case .forYou:
            return AppConstants.Strings.Tab.forYou
        }
    }

    var systemImage: String {
        switch self {
        case .home:
            return AppConstants.Images.Tab.home
        case .forYou:
            return AppConstants.Images.Tab.forYou
        }
    }
}


