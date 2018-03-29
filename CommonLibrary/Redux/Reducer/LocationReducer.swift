import CoreLocation
import Foundation
import KleinKit

public struct LocationReducer: Reducer {
    public func reduce(_ currentState: AppState, action: Action) -> AppState {
        guard let locationAction = action as? LocationAction else { return currentState }

        var stateCopy = currentState

        switch locationAction {
        case .permissionChanged(let newPermission):
            stateCopy.deviceState.locationPermission = newPermission
        case .receivedNewLocations(let locations):
            stateCopy.currentActivity?.locations.append(contentsOf: locations)
        case .receivedNewSignificantLocation(let location, let id, let photoTask):
            guard var activity = stateCopy.currentActivity,
                activity.state == .inProgress else { return currentState }
            let point = SnapshotPoint(identifier: id,
                                      location: location,
                                      photo: .loading(task: photoTask, oldValue: nil),
                                      time: now())
            activity.snapshotPoints.insert(point, at: 0)
            stateCopy.currentActivity = activity
        }
        return stateCopy
    }
}

extension LocationReducer: HasToday { }
