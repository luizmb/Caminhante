//
//  BootstrapActionRequest.swift
//  Caminhante
//
//  Created by Luiz Rodrigo Martins Barbosa on 04.03.18.
//

import CommonLibrary
import CoreLocation
import HealthKit
import KleinKit
import UIKit

enum BootstrapActionRequest: ActionRequest {
    case boot(UIApplication, UINavigationController)

    func execute(getState: @escaping () -> AppState,
                 dispatch: @escaping DispatchFunction,
                 dispatchAsync: @escaping (AnyActionAsync<AppState>) -> Void) {
        switch self {
        case .boot(let application, let navigationController):
            dispatch(RouterAction.didStart(application, navigationController))

            locationTracker.requestAuthorization()
            healthKitTracker.requestAuthorization()
        }
    }
}

extension BootstrapActionRequest: HasLocationTracker { }
extension BootstrapActionRequest: HasHealthKitTracker { }
