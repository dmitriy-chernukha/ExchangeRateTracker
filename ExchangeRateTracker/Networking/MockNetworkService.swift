import Foundation

final class MockNetworkService: NetworkServiceProtocol, @unchecked Sendable {
    var result: Result<CurrencyRates, Error>

    init(result: Result<CurrencyRates, Error>) {
        self.result = result
    }

    func fetch<T>(_ endpoint: APIEndpoint) async throws -> T where T : Decodable {
        switch result {
        case .success(let response):
            return response as! T
        case .failure(let error):
            throw error
        }
    }
}
