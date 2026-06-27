//
//  APIClient.swift
//  CanadaDigitalNews
//
//  Created by Sonam Gour on 13/05/26.
//

import Foundation

// NewsApp/Shared/Networking/APIClient.swift

import Foundation

protocol APIClientProtocol {
    func request<T: Decodable>(endpoint: APIEndpoint) async throws -> T
}

final class APIClient: APIClientProtocol {

    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared) {
        self.session = session

        // Decoder is configured once and reused for every request.
        // .iso8601 handles dates like "2024-11-15T10:30:00Z" — NewsAPI's format.
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        self.decoder = decoder
    }

    func request<T: Decodable>(endpoint: APIEndpoint) async throws -> T {
        let request = try RequestBuilder.build(endpoint: endpoint)

        // Catch URLError separately so network failures throw a typed APIError
        // instead of leaking raw URLError to callers.
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

        // Map HTTP status codes to specific typed errors.
        // Callers can show different messages for unauthorized vs rate-limited vs server-down.
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

        // Preserve the underlying decoding error so debugging stays possible.
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decodingFailed(error)
        }
    }
}
