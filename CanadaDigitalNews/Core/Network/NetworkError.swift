//  NetworkError.swift
//  CanadaDigitalNews
//  Created by Sonam Gour on 13/05/26.

import Foundation

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case invalidStatusCode
    case decodingFailed
    
    var errorDescription: String {
        switch self {
            
        case .invalidURL:
            return "Invalid URL"
            
        case .invalidResponse:
            return "invalidResponse"
            
        case .invalidStatusCode:
            return "invalidStatusCode"
            
        case .decodingFailed:
            return "decodingFailed"

        }
    }
}
