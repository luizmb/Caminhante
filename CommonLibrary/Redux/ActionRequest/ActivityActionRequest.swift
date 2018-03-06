//
//  ActivityActionRequest.swift
//  Caminhante
//
//  Created by Luiz Rodrigo Martins Barbosa on 04.03.18.
//

import CoreLocation
import Foundation
import KleinKit

public enum ActivityActionRequest: Int, Codable {
    public static let className = String(describing: ActivityActionRequest.self)

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

        switch state.deviceState.deviceType {
        case .appleWatch:
            handleAppleWatch(getState: getState, dispatch: dispatch, dispatchAsync: dispatchAsync)
        case .iPhone:
            handleiPhone(getState: getState, dispatch: dispatch, dispatchAsync: dispatchAsync)
        }
    }

    public func handleAppleWatch(getState: @escaping () -> AppState,
                                 dispatch: @escaping DispatchFunction,
                                 dispatchAsync: @escaping (AnyActionAsync<AppState>) -> Void) {
        let state = getState()

        switch self {
        case .startActivity:
            guard state.deviceState.locationPermission == .authorized else { return }
            guard state.currentActivity == nil || state.currentActivity?.state != .inProgress else { return }

            locationTracker.start()
            dispatch(ActivityAction.activityDidStart)
            dispatch(RouterAction.didNavigate(.activityPhotoStream))
        case .pauseActivity:
            guard state.currentActivity?.state == .inProgress else { return }

            locationTracker.stop()
            dispatch(ActivityAction.activityDidPause)
        case .finishActivity:
            guard state.currentActivity?.state == .inProgress || state.currentActivity?.state == .paused else { return }

            locationTracker.stop()
            dispatch(ActivityAction.activityDidFinish)
        case .resetActivity:
            guard state.currentActivity?.state == .finished else { return }

            locationTracker.stop()
            dispatch(ActivityAction.activityDidReset)
        }
    }

    public func handleiPhone(getState: @escaping () -> AppState,
                             dispatch: @escaping DispatchFunction,
                             dispatchAsync: @escaping (AnyActionAsync<AppState>) -> Void) {
        let state = getState()

        switch self {
        case .startActivity:
            guard state.deviceState.locationPermission == .authorized else { return }
            remoteDevice.send(type: ActivityActionRequest.className,
                              data: [ActivityActionRequest.className: ActivityActionRequest.startActivity]) { response in
                if case .failure = response {
                    print("Error controlling Apple Watch")
                }
            }
        case .pauseActivity:
            remoteDevice.send(type: ActivityActionRequest.className,
                              data: [ActivityActionRequest.className: ActivityActionRequest.pauseActivity]) { response in
                if case .failure = response {
                    print("Error controlling Apple Watch")
                }
            }
        case .finishActivity:
            remoteDevice.send(type: ActivityActionRequest.className,
                              data: [ActivityActionRequest.className: ActivityActionRequest.finishActivity]) { response in
                if case .failure = response {
                    print("Error controlling Apple Watch")
                }
            }
        case .resetActivity:
            remoteDevice.send(type: ActivityActionRequest.className,
                              data: [ActivityActionRequest.className: ActivityActionRequest.resetActivity]) { response in
                if case .failure = response {
                    print("Error controlling Apple Watch")
                }
            }
        }
    }
}

extension ActivityActionRequest: HasLocationTracker { }
extension ActivityActionRequest: HasRemoteDevice { }
