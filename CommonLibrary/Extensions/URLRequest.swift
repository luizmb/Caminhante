import Foundation
import KleinKit

extension URLRequest {
    public static func createRequest(url urlString: String,
                                     httpMethod: String,
                                     urlParams: [String: String] = [:]) -> URLRequest {
        let urlSuffix = urlParams.isEmpty ? "" : "?" + urlParams.map { key, value in "\(key)=\(value)" }.joined(separator: "&")
        let url = URL(string: "\(urlString)\(urlSuffix)")!
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        return request
    }

    public func appendingParameter(key: String, value: String) -> URLRequest {
        guard let url = self.url else { return self }
        let appendingChar = url.absoluteString.contains("?") ? "&" : "?"

        var copy = self
        copy.url = URL(string: url.absoluteString + appendingChar + "\(key)=\(value)")

        return copy
    }
}
