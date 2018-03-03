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
        case .startActivity:
            stateCopy.currentActivity = stateCopy.currentActivity ?? Activity(state: .inProgress, snapshotPoints: [])
            stateCopy.currentActivity?.state = .inProgress
        case .pauseActivity:
            stateCopy.currentActivity = stateCopy.currentActivity ?? Activity(state: .paused, snapshotPoints: [])
            stateCopy.currentActivity?.state = .paused
        case .finishActivity:
            stateCopy.currentActivity = stateCopy.currentActivity ?? Activity(state: .finished, snapshotPoints: [])
            stateCopy.currentActivity?.state = .finished
        case .resetActivity:
            stateCopy.currentActivity = nil
        }
        return stateCopy
    }
}
