//
//  WorkoutReducer.swift
//  Caminhante
//
//  Created by Luiz Rodrigo Martins Barbosa on 04.03.18.
//

import Foundation
import KleinKit

public struct WorkoutReducer: Reducer {
    public func reduce(_ currentState: AppState, action: Action) -> AppState {
        guard let workoutAction = action as? WorkoutAction else { return currentState }

        var stateCopy = currentState

        switch workoutAction {
        case .permissionChanged(let newPermission):
            stateCopy.deviceState.healthPermission = newPermission
        }
        return stateCopy
    }
}
