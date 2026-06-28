//  APIEndpoint.swift
//  CanadaDigitalNews
//  Created by Sonam Gour on 13/05/26.

import Foundation

// MARK: - Protocol

/// Describes one API endpoint — its URL, method, query params, and headers.
/// Any new endpoint just adds a case to a conforming enum.
protocol APIEndpoint: Sendable {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem] { get }
    var header: [String: String]? { get }
    var body: [String: Any]? { get }
}

// MARK: - NewsAPIEndpoint
/// All NewsAPI endpoints used in the app.
/// Adding a new endpoint = adding a new case + updating the switches below.

enum NewsAPIEndpoint: APIEndpoint {
    
    case topHeadlines(country: String)
    case search(query: String)
    
    // MARK: - Base URL
    
    var baseURL: String {
        return APIConstants.baseURL
    }

    // MARK: - Path
    
    var path: String {
        switch self {
        case .topHeadlines:
            return "/top-headlines"
        case .search:
            return "/everything"
        }
    }
    
    // MARK: - Method
    
    var method: HTTPMethod {
        switch self {
        case .topHeadlines:
            return .get
        case .search:
            return .get
        }
    }
    
    // MARK: - Query items

    var queryItems: [URLQueryItem] {
        switch self {
        case .topHeadlines(let country):
            return [URLQueryItem(name: "country", value: country)]
        case .search(let query):
            return [URLQueryItem(name: "q", value: query)]
        }
    }
    
    // MARK: - Headers
 
    var header: [String: String]? {
        [
            "Accept": "application/json",
            "X-Api-Key": APIConstants.apiKey
        ]
    }

    // MARK: - Body

    var body: [String : Any]? {
        return nil
    }
}


