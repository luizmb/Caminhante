//
//  RouterReducer.swift
//  Caminhante
//
//  Created by Luiz Rodrigo Martins Barbosa on 03.03.18.
//

import Foundation
import KleinKit

public struct RouterReducer: Reducer {
    public func reduce(_ currentState: AppState, action: Action) -> AppState {
        guard let routerAction = action as? RouterAction else { return currentState }

        var stateCopy = currentState

        #if os(iOS)
            switch routerAction {
            case .didStart(let application):
                stateCopy.deviceState.application = application
                stateCopy.deviceState.navigation = .root()
            case .didNavigate(let destination):
                stateCopy.deviceState.navigation = destination
            }
        #else
            switch routerAction {
            case .didStart:
                stateCopy.deviceState.navigation = .root()
            case .didNavigate(let destination):
                stateCopy.deviceState.navigation = destination
            }
        #endif

        return stateCopy
    }
}
