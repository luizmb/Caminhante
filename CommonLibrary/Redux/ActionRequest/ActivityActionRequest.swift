//
//  ActivityActionRequest.swift
//  Caminhante
//
//  Created by Luiz Rodrigo Martins Barbosa on 04.03.18.
//

import CoreLocation
import Foundation
import KleinKit

public enum ActivityActionRequest {
    case startActivity
    case pauseActivity
    case finishActivity
    case resetActivity
}

extension ActivityActionRequest: ActionRequest {
    public func execute(getState: @escaping () -> AppState,
                        dispatch: @escaping DispatchFunction,
                        dispatchAsync: @escaping (AnyActionAsync<AppState>) -> Void) {
        let state = getState()
        switch self {
        case .startActivity:
            guard state.deviceState.locationPermission == .authorized else { return }
            locationTracker.start()
            dispatch(ActivityAction.activityDidStart)
        case .pauseActivity:
            locationTracker.stop()
            dispatch(ActivityAction.activityDidPause)
        case .finishActivity:
            locationTracker.stop()
            dispatch(ActivityAction.activityDidFinish)
        case .resetActivity:
            locationTracker.stop()
            dispatch(ActivityAction.activityDidReset)
        }
    }
}

extension ActivityActionRequest: HasLocationTracker { }
