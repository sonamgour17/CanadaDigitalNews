//
//  AppRoute.swift
//  CanadaDigitalNews
//
//  Created by Sonam Gour on 27/06/26.
//

import Foundation

/// Defines the navigation routes used in the app.
enum AppRoute: Hashable {
    
    /// Opens the article detail screen using the selected article ID.
    case articleDetail(articleID: String)
}
