//
//  APIClient.swift
//  CanadaDigitalNews
//
//  Created by Sonam Gour on 13/05/26.
//

import Foundation

protocol APIClientProtocol {
    func request<T: Decodable>(endpoint: APIEndpoint, responseType: T.Type) async throws -> T
}

final class APIClient: APIClientProtocol {

    static let shared = APIClient()
    private init() {}

    func request<T: Decodable>(
        endpoint: APIEndpoint,
        responseType: T.Type
    ) async throws -> T {

        let request = try RequestBuilder.build(endpoint: endpoint)

        print("Request URL:", request.url?.absoluteString ?? "nil")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        print("Status Code:", httpResponse.statusCode)

        guard (200...299).contains(httpResponse.statusCode) else {
            let body = String(data: data, encoding: .utf8)
            print("Error Body:", body ?? "nil")
            throw APIError.invalidStatusCode
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("Decoding Error:", error)
            throw APIError.decodingFailed
        }
    }
}
