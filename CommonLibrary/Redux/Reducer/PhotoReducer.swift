//
//  PhotoReducer.swift
//  Caminhante
//
//  Created by Luiz Rodrigo Martins Barbosa on 04.03.18.
//

import CoreLocation
import Foundation
import KleinKit

public struct PhotoReducer: Reducer {
    public func reduce(_ currentState: AppState, action: Action) -> AppState {
        guard let photoAction = action as? PhotoAction else { return currentState }

        var stateCopy = currentState

        switch photoAction {
        case .gotPhotoInformation(let photoInformation, let location):
            guard var activity = stateCopy.currentActivity,
                let index = activity.snapshotPoints.index(where: { $0.location === location }),
                var snapshot = activity.snapshotPoints[safe: index] else { return currentState }
            snapshot.photo = .loaded(photoInformation)
            activity.snapshotPoints[index] = snapshot
            stateCopy.currentActivity = activity
        }
        return stateCopy
    }
}
