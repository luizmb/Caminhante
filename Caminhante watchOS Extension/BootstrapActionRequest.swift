//
//  BootstrapActionRequest.swift
//  Caminhante watchOS Extension
//
//  Created by Luiz Rodrigo Martins Barbosa on 03.03.18.
//

import CommonLibrary
import KleinKit
import WatchKit

enum BootstrapActionRequest: ActionRequest {
    case boot

    func execute(getState: @escaping () -> AppState,
                 dispatch: @escaping DispatchFunction,
                 dispatchAsync: @escaping (AnyActionAsync<AppState>) -> Void) {
        switch self {
        case .boot:
            dispatch(RouterAction.didStart)
        }
    }
}
