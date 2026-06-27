//  APIEndpoint.swift
//  CanadaDigitalNews
//  Created by Sonam Gour on 13/05/26.

import Foundation

protocol APIEndpoint: Sendable {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem] { get }
    var header: [String: String]? { get }
    var body: [String: Any]? { get }
}

enum NewsAPIEndpoint: APIEndpoint {
    
    case topHeadlines(country: String)
    case search(query: String)
    
    var baseURL: String {
        return APIConstants.baseURL
    }

    var path: String {
        switch self {
        case .topHeadlines:
            return "/top-headlines"
        case .search:
            return "/everything"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .topHeadlines:
            return .get
        case .search:
            return .get
        }
    }

    var queryItems: [URLQueryItem] {
        switch self {
        case .topHeadlines(let country):
            return [URLQueryItem(name: "country", value: country)]
        case .search(let query):
            return [URLQueryItem(name: "q", value: query)]
        }
    }

 
    var header: [String: String]? {
        [
            "Accept": "application/json",
            "X-Api-Key": APIConstants.apiKey
        ]
    }

    var body: [String : Any]? {
        return nil
    }
}


