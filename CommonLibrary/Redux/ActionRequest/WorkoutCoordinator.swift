//
//  WorkoutCoordinator.swift
//  Caminhante watchOS Extension
//
//  Created by Luiz Rodrigo Martins Barbosa on 04.03.18.
//

import CoreLocation
import Foundation
import KleinKit

public enum WorkoutCoordinator {
    case gotNewLocation(location: CLLocation)
}

extension WorkoutCoordinator: ActionRequest {
    public func execute(getState: @escaping () -> AppState,
                        dispatch: @escaping DispatchFunction,
                        dispatchAsync: @escaping (AnyActionAsync<AppState>) -> Void) {
        switch self {
        case .gotNewLocation(let location):
            let currentState = getState()
            guard let activity = currentState.currentActivity,
                activity.state == .inProgress else { return }

            let significantChange = currentState.significantDistance.converted(to: .meters).value

            if let lastKnownLocation = activity.snapshotPoints.last?.location,
                location.distance(from: lastKnownLocation) < significantChange {
                return
            }

            // Either it's the first point or distance from last point is significant

            let task = photoAPI.request(.publicPhotosNearby(location: location.coordinate,
                                                            page: 1,
                                                            pageSize: 1)) { result in
                let photo: Result<PhotoInformation> = result.flatMap(JsonParser.decode)
                dispatch(PhotoAction.gotPhotoInformation(photo, at: location) )
            }

            dispatch(LocationAction.receivedNewSignificantLocation(location: location,
                                                                   photoTask: task))
        }
    }
}

extension WorkoutCoordinator: HasPhotoAPI { }
