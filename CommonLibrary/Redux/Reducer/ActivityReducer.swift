//
//  ActivityReducer.swift
//  Caminhante
//
//  Created by Luiz Rodrigo Martins Barbosa on 03.03.18.
//

import Foundation
import KleinKit

public struct ActivityReducer: Reducer {
    public func reduce(_ currentState: AppState, action: Action) -> AppState {
        guard let activityAction = action as? ActivityAction else { return currentState }

        var stateCopy = currentState

        switch activityAction {
        case .activityDidStart:
            stateCopy.currentActivity = stateCopy.currentActivity ?? Activity(state: .inProgress, snapshotPoints: [])
            stateCopy.currentActivity?.state = .inProgress
            stateCopy.currentActivity?.startDate = Date()
        case .activityDidPause:
            stateCopy.currentActivity = stateCopy.currentActivity ?? Activity(state: .paused, snapshotPoints: [])
            stateCopy.currentActivity?.state = .paused
        case .activityDidFinish:
            stateCopy.currentActivity = stateCopy.currentActivity ?? Activity(state: .finished, snapshotPoints: [])
            stateCopy.currentActivity?.state = .finished
            stateCopy.currentActivity?.endDate = Date()
        case .activityDidReset:
            stateCopy.currentActivity = nil
        case .healthTrackerDidWalkDistance(let distance):
            guard let activity = stateCopy.currentActivity else { return currentState }
            stateCopy.currentActivity?.totalDistance = activity.totalDistance + distance
        case .healthTrackerDidBurnEnergy(let energy):
            guard let activity = stateCopy.currentActivity else { return currentState }
            stateCopy.currentActivity?.totalEnergyBurned = activity.totalEnergyBurned + energy
        }
        return stateCopy
    }
}
