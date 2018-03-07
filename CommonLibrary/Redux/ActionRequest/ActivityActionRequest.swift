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

    case startActivity = 0
    case pauseActivity = 1
    case finishActivity = 2
    case resetActivity = 3
    case healthTrackerDidFinish = 4
    case healthTrackerDidStart = 5
}
//
//extension ActivityActionRequest: Codable {
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        let value = try container.decode(Int.self)
//        switch value {
//        case 0: self = .startActivity
//        case 1: self = .pauseActivity
//        case 2: self = .finishActivity
//        case 3: self = .resetActivity
//        default:
//            throw DecodingError.valueNotFound(Int.self,
//                                              DecodingError.Context(codingPath: decoder.codingPath,
//                                                                    debugDescription: "Only the types 0 to 3 are allowed to be codable"))
//        }
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        switch self {
//        case .startActivity: try container.encode(0)
//        case .pauseActivity: try container.encode(1)
//        case .finishActivity: try container.encode(2)
//        case .resetActivity: try container.encode(3)
//        default:
//            throw EncodingError.invalidValue(4,
//                                             EncodingError.Context(codingPath: encoder.codingPath,
//                                                                   debugDescription: "Only the types 0 to 3 are allowed to be codable"))
//       }
//    }
//}

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
            if state.currentActivity?.state == .paused {
                healthKitTracker.resume()
            } else {
                healthKitTracker.start()
            }
        case .pauseActivity:
            guard state.currentActivity?.state == .inProgress else { return }

            locationTracker.stop()
            dispatch(ActivityAction.activityDidPause)
            healthKitTracker.pause()
        case .finishActivity:
            guard state.currentActivity?.state == .inProgress || state.currentActivity?.state == .paused else { return }

            locationTracker.stop()
            dispatch(ActivityAction.activityDidFinish)
            healthKitTracker.stop()
        case .resetActivity:
            guard state.currentActivity?.state == .finished else { return }

            locationTracker.stop()
            dispatch(ActivityAction.activityDidReset)
            healthKitTracker.reset()
        case .healthTrackerDidStart:
            guard let activity = state.currentActivity,
                let startDate = activity.startDate else { return }
            healthKitTracker.startAccumulatingData(from: startDate)
        case .healthTrackerDidFinish:
            guard let activity = state.currentActivity,
                let startDate = activity.startDate,
                let endDate = activity.endDate else { return }
            healthKitTracker.save(from: startDate,
                                  to: endDate,
                                  distance: activity.totalDistance,
                                  energy: activity.totalEnergyBurned,
                                  locations: activity.locations)
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
        case .healthTrackerDidStart, .healthTrackerDidFinish:
            break
        }
    }
}

extension ActivityActionRequest: HasLocationTracker { }
extension ActivityActionRequest: HasHealthKitTracker { }
extension ActivityActionRequest: HasRemoteDevice { }
