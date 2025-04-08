
import Foundation

enum APIErrors: Error {
    case invalidURL
    case serverError(statusCode: Int)
    case decodingError(underlying: Error)

    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "errorInvalidUrl"
        case .decodingError(let underlying):
            return "errorDecoding \(underlying.localizedDescription)"
        case .serverError(let statusCode):
            return "errorServer \(statusCode)."
        }
    }
}
