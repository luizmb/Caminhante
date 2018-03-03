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
            case .didStart(let application, let navigationController):
                stateCopy.deviceState.application = application
                stateCopy.deviceState.navigation = .still(at: .root())
                stateCopy.deviceState.navigationController = navigationController
//            case .willNavigate(let route):
//                stateCopy.navigation = .navigating(route)
//            case .didNavigate(let destination):
//                stateCopy.navigation = .still(at: destination)
            }
        #else
            switch routerAction {
            case .didStart:
                stateCopy.deviceState.navigation = .still(at: .root())
//            case .willNavigate(let route):
//                stateCopy.navigation = .navigating(route)
//            case .didNavigate(let destination):
//                stateCopy.navigation = .still(at: destination)
            }
        #endif

        return stateCopy
    }
}
