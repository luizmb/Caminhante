//
//  LocationReducer.swift
//  Caminhante
//
//  Created by Luiz Rodrigo Martins Barbosa on 04.03.18.
//

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
        case .receivedNewSignificantLocation(let location, let photoTask):
            guard var activity = stateCopy.currentActivity,
                activity.state == .inProgress else { return currentState }
            let point = SnapshotPoint(location: location,
                                      photo: .syncing(task: photoTask, oldValue: nil),
                                      time: Date())
            activity.snapshotPoints.append(point)
            stateCopy.currentActivity = activity
        }
        return stateCopy
    }
}
