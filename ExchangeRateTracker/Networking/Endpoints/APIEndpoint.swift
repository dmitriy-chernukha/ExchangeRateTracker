import Foundation

protocol APIEndpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: String { get }
    var headers: [String: String] { get }
    var queryParameters: [String: String] { get }
}

extension APIEndpoint {
    var url: URL? {
        guard var components = URLComponents(string: baseURL + path) else { return nil }
        if !queryParameters.isEmpty {
            components.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        return components.url
    }
}
