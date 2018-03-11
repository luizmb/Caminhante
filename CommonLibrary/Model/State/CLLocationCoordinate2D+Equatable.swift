import CoreLocation
import Foundation

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return
            fabs(lhs.latitude - rhs.latitude) < Double.ulpOfOne &&
            fabs(lhs.longitude - rhs.longitude) < Double.ulpOfOne
    }
}
