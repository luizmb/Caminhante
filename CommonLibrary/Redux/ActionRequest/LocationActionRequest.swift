import CoreLocation
import Foundation
import KleinKit
#if os(iOS)
import UIKit
#endif

public enum LocationActionRequest {
    case evaluateNewLocations([CLLocation])
    case reviewPermissions
}

extension LocationActionRequest: ActionRequest {
    public func execute(getState: @escaping () -> AppState,
                        dispatch: @escaping DispatchFunction,
                        dispatchAsync: @escaping (AnyActionAsync<AppState>) -> Void) {
        switch self {
        case .evaluateNewLocations(let locations):
            let currentState = getState()

            guard let activity = currentState.currentActivity,
                activity.state == .inProgress else { return }

            let filteredLocations = locations.filter { (location: CLLocation) -> Bool in
                location.horizontalAccuracy <= kCLLocationAccuracyNearestTenMeters
            }

            guard !filteredLocations.isEmpty, let mostRecentLocation = filteredLocations.last else { return }
            dispatch(LocationAction.receivedNewLocations(filteredLocations))
            healthTracker.appendLocations(filteredLocations)

            let significantChange = currentState.significantDistance.converted(to: .meters).value

            if let lastKnownLocation = activity.snapshotPoints.first?.location,
                mostRecentLocation.distance(from: lastKnownLocation) < significantChange {
                return
            }

            // Either it's the first point or distance from last point is significant
            dispatchAsync(AnyActionAsync(PhotoActionRequest.startSnapshotProcess(newLocation: mostRecentLocation)))
        case .reviewPermissions:
            #if os(iOS)
            guard let app = getState().deviceState.application else { return }
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else { return }

            if app.canOpenURL(settingsUrl) {
                app.open(settingsUrl, options: [:], completionHandler: nil)
            }
            #endif
        }
    }
}

extension LocationActionRequest: HasHealthTracker { }
