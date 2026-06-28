//
//  APIClient.swift
//  CanadaDigitalNews
//
//  Created by Sonam Gour on 13/05/26.
//

import Foundation

// NewsApp/Shared/Networking/APIClient.swift

import Foundation

// MARK: - Protocol

/// Sends API requests and decodes the response.
/// Other code uses this protocol, not the concrete class — easier to test.
protocol APIClientProtocol {
    func request<T: Decodable>(endpoint: APIEndpoint) async throws -> T
}

// MARK: - APIClient

final class APIClient: APIClientProtocol {

    // MARK: - Properties

    private let session: URLSession
    private let decoder: JSONDecoder
    
    // MARK: - Init

    init(session: URLSession = .shared) {
        self.session = session

        // Set up the decoder once and reuse it.
        // .iso8601 handles dates like "2024-11-15T10:30:00Z" from NewsAPI.
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        self.decoder = decoder
    }

    // MARK: - Request

    func request<T: Decodable>(endpoint: APIEndpoint) async throws -> T {
        let request = try RequestBuilder.build(endpoint: endpoint)

        // Catch network errors separately so callers get a clear APIError.
        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
        } catch let error as URLError {
            throw APIError.networkFailure(error)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        // Turn each HTTP status code into a specific error.
        switch httpResponse.statusCode {
        case 200...299:
            break
        case 401:
            throw APIError.unauthorized
        case 403:
            throw APIError.forbidden
        case 429:
            throw APIError.rateLimited
        case 500...599:
            throw APIError.serverError(httpResponse.statusCode)
        default:
            throw APIError.unexpectedStatus(httpResponse.statusCode)
        }

        // Keep the original decoding error so we can debug bad JSON later.
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decodingFailed(error)
        }
    }
}
