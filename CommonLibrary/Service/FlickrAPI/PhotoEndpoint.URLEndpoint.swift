import Foundation
import KleinKit

extension PhotoServiceEndpoint {
    private var httpMethod: String {
        switch self {
        case .publicPhotosNearby: return "GET"
        case .publicPhoto: return "GET"
        }
    }
}

extension PhotoServiceEndpoint: URLEndpoint {
    public func urlRequest(with baseUrl: String) -> URLRequest {
        switch self {
        case let .publicPhotosNearby(location, page, pageSize):
            return URLRequest.createRequest(url: baseUrl,
                                            httpMethod: httpMethod,
                                            urlParams: [
                                                "method": "flickr.photos.search",
                                                "lat": "\(location.latitude)",
                                                "lon": "\(location.longitude)",
                                                "radius": "1",
                                                "radius_units": "km",
                                                "safe_search": "2",
                                                "per_page": "\(pageSize)",
                                                "page": "\(page)",
                                                "nojsoncallback": "1",
                                                "format": "json"
                ])
        case .publicPhoto(let url):
            return URLRequest.createRequest(url: url.absoluteString, httpMethod: httpMethod)
        }
    }
}
