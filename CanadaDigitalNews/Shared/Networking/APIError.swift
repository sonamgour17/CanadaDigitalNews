//  NetworkError.swift
//  CanadaDigitalNews
//  Created by Sonam Gour on 13/05/26.


import Foundation

/// Represents possible errors that can happen while calling an API.
/// Conforms to `LocalizedError` so each error can provide a user-friendly message.
enum APIError: LocalizedError {
    
    // MARK: - Error Cases
    
    case invalidURL
    case invalidResponse
    case unauthorized           // 401
    case forbidden              // 403
    case rateLimited            // 429
    case serverError(Int)       // 500-599
    case unexpectedStatus(Int)  // anything else non-2xx
    
    /// Keeps the original decoding error for debugging.
    case decodingFailed(Error)
    
    /// Keeps the original URL error, such as no internet, timeout, or lost connection.
    case networkFailure(URLError)
    
    // MARK: - LocalizedError

    /// User-friendly error message shown in the UI.
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Couldn't build a valid request."
        case .invalidResponse:
            return "Invalid response from server."
        case .unauthorized:
            return "API key is invalid or missing."
        case .forbidden:
            return "Access denied. You may have hit the API limit."
        case .rateLimited:
            return "Too many requests. Please wait and try again."
        case .serverError(let code):
            return "Server error (\(code)). Please try again later."
        case .unexpectedStatus(let code):
            return "Unexpected response (\(code))."
        case .decodingFailed:
            return "Couldn't read the server's response."
        case .networkFailure:
            return "Network connection failed. Check your internet."
        }
    }
}
