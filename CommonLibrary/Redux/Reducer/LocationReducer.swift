//
//  LocationReducer.swift
//  Caminhante
//
//  Created by Luiz Rodrigo Martins Barbosa on 04.03.18.
//

import Foundation
import KleinKit

public struct LocationReducer: Reducer {
    public func reduce(_ currentState: AppState, action: Action) -> AppState {
        guard let locationAction = action as? LocationAction else { return currentState }

        var stateCopy = currentState

        switch locationAction {
        case .permissionChanged(let newPermission):
            stateCopy.deviceState.locationPermission = newPermission
        case .receivedNewLocation(let latitude, let longitude):
            // TODO: Implement
            break
        }
        return stateCopy
    }
}
