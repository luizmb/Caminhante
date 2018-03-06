//
//  BootstrapActionRequest.swift
//  Caminhante watchOS Extension
//
//  Created by Luiz Rodrigo Martins Barbosa on 03.03.18.
//

import CommonLibrary
import CoreLocation
import HealthKit
import KleinKit
import WatchKit

enum BootstrapActionRequest: ActionRequest {
    case boot

    func execute(getState: @escaping () -> AppState,
                 dispatch: @escaping DispatchFunction,
                 dispatchAsync: @escaping (AnyActionAsync<AppState>) -> Void) {
        switch self {
        case .boot:
            WKInterfaceController.reloadRootPageControllers(withNames: [NavigationTree.activityControls.controller,
                                                                        NavigationTree.activityPhotoStream.controller],
                                                            contexts: nil,
                                                            orientation: WKPageOrientation.horizontal,
                                                            pageIndex: 0)

            dispatch(RouterAction.didStart)

            locationTracker.requestAuthorization()
            healthKitTracker.requestAuthorization()
            remoteDevice.activateSession()
        }
    }
}

extension BootstrapActionRequest: HasLocationTracker { }
extension BootstrapActionRequest: HasHealthKitTracker { }
extension BootstrapActionRequest: HasRemoteDevice { }
