import CoreLocation
import Foundation

public enum PhotoServiceEndpoint {
    case publicPhotosNearby(location: CLLocationCoordinate2D, page: Int, pageSize: Int)
    case publicPhoto(url: URL)
}
