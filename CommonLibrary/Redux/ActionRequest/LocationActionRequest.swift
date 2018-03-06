//
//  LocationActionRequest.swift
//  Caminhante
//
//  Created by Luiz Rodrigo Martins Barbosa on 04.03.18.
//

import CoreLocation
import Foundation
import KleinKit
#if os(iOS)
import UIKit
#endif

public enum LocationActionRequest {
    case evaluateNewLocation(location: CLLocation)
    case reviewPermissions
}

extension LocationActionRequest: ActionRequest {
    public func execute(getState: @escaping () -> AppState,
                        dispatch: @escaping DispatchFunction,
                        dispatchAsync: @escaping (AnyActionAsync<AppState>) -> Void) {
        switch self {
        case .evaluateNewLocation(let location):
            let currentState = getState()
            guard let activity = currentState.currentActivity,
                activity.state == .inProgress else { return }

            let significantChange = currentState.significantDistance.converted(to: .meters).value

            if let lastKnownLocation = activity.snapshotPoints.first?.location,
                location.distance(from: lastKnownLocation) < significantChange {
                return
            }

            // Either it's the first point or distance from last point is significant
            dispatchAsync(AnyActionAsync(PhotoActionRequest.startSnapshotProcess(newLocation: location)))
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
