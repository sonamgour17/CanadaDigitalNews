//  RequestBuilder.swift
//  CanadaDigitalNews
//  Created by Sonam Gour on 13/05/26.

import Foundation

struct RequestBuilder {
    
    static func build(endpoint: APIEndpoint) throws -> URLRequest {

        guard var components = URLComponents(string: endpoint.baseURL + endpoint.path) else {
            throw APIError.invalidURL
        }

        components.queryItems = endpoint.queryItems

        guard let url = components.url else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header

        if let body = endpoint.body {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        }

        return request
    }
}
