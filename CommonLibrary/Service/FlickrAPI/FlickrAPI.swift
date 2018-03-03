//
//  FlickrAPI.swift
//  Caminhante
//
//  Created by Luiz Rodrigo Martins Barbosa on 03.03.18.
//

import Foundation
import KleinKit

public class FlickrAPI: PhotoAPI {
    private static var baseUrl: String {
        return flickrURL
    }

    private static var apiKey: String {
        return flickrApiKey
    }

    public static let shared: PhotoAPI = {
        let global = FlickrAPI(session: URLSession.shared)
        return global
    }()

    enum FlickrAPIError: Error {
        case invalidResponse
        case statusCodeError(statusCode: Int, data: Data?)
    }

    let session: URLSession

    init(session: URLSession) {
        self.session = session
    }

    @discardableResult public func request(_ endpoint: PhotoServiceEndpoint,
                                           completion: @escaping (Result<Data>) -> Void) -> CancelableTask {
        let endpoint = endpoint.urlRequest(with: FlickrAPI.baseUrl)
                               .appendingParameter(key: "api_key", value: FlickrAPI.apiKey)
        let task = session.dataTask(with: endpoint) { data, response, error in
            switch (error, response as? HTTPURLResponse) {
            case (.some(let err), _): completion(.failure(err))
            case (.none, .none): completion(.failure(FlickrAPIError.invalidResponse))
            case (.none, .some(let httpResponse)) where httpResponse.statusCode >= 300:
                completion(.failure(FlickrAPIError.statusCodeError(statusCode: httpResponse.statusCode, data: data)))
            default:
                completion(.success(data!))
            }
        }
        task.resume()
        return task
    }
}
