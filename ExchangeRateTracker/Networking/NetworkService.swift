//
//  NetworkService.swift
//  ExchangeRateTracker
//

import Foundation

protocol NetworkServiceProtocol: Sendable {
    func fetch<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T
}

final class NetworkService: NetworkServiceProtocol {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetch<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T {
        guard let url = endpoint.url else {
            throw APIErrors.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method
        request.allHTTPHeaderFields = endpoint.headers

        let (data, response) = try await session.data(for: request)
                        

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIErrors.serverError(statusCode: 0)
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIErrors.serverError(statusCode: httpResponse.statusCode)
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIErrors.decodingError(underlying: error)
        }
    }
}
