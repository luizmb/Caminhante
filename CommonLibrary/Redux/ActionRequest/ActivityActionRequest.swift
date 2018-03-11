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

extension ActivityActionRequest: ActionRequest {
    public func execute(getState: @escaping () -> AppState,
                        dispatch: @escaping DispatchFunction,
                        dispatchAsync: @escaping (AnyActionAsync<AppState>) -> Void) {
        let state = getState()

        switch (self, state.deviceState.deviceType) {
        case (.startActivity, .appleWatch):
            watchStartActivity(state: state, dispatch: dispatch)
        case (.startActivity, .iPhone):
            phoneStartActivity(state: state, dispatch: dispatch)

        case (.pauseActivity, .appleWatch):
            watchPauseActivity(state: state, dispatch: dispatch)
        case (.pauseActivity, .iPhone):
            phonePauseActivity(state: state, dispatch: dispatch)

        case (.finishActivity, .appleWatch):
            watchFinishActivity(state: state, dispatch: dispatch)
        case (.finishActivity, .iPhone):
            phoneFinishActivity(state: state, dispatch: dispatch)

        case (.resetActivity, .appleWatch):
            watchResetActivity(state: state, dispatch: dispatch)
        case (.resetActivity, .iPhone):
            phoneResetActivity(state: state, dispatch: dispatch)

        case (.healthTrackerDidStart, .appleWatch):
            watchHealthTrackerDidStart(state: state, dispatch: dispatch)
        case (.healthTrackerDidStart, .iPhone):
            break

        case (.healthTrackerDidFinish, .appleWatch):
            watchHealthTrackerDidFinish(state: state, dispatch: dispatch)
        case (.healthTrackerDidFinish, .iPhone):
            break
        }
    }
}

// MARK: - Apple Watch actions
extension ActivityActionRequest {
    private func watchStartActivity(state: AppState, dispatch: @escaping DispatchFunction) {
        guard state.deviceState.locationPermission == .authorized else { return }
        guard state.currentActivity == nil || state.currentActivity?.state != .inProgress else { return }

        locationTracker.start()
        dispatch(ActivityAction.activityDidStart)
        dispatch(RouterAction.didNavigate(.activityPhotoStream))
        if state.currentActivity?.state == .paused {
            healthTracker.resume()
        } else {
            healthTracker.start()
        }
    }

    private func watchPauseActivity(state: AppState, dispatch: @escaping DispatchFunction) {
        guard state.currentActivity?.state == .inProgress else { return }

        locationTracker.stop()
        dispatch(ActivityAction.activityDidPause)
        healthTracker.pause()
    }

    private func watchFinishActivity(state: AppState, dispatch: @escaping DispatchFunction) {
        guard state.currentActivity?.state == .inProgress || state.currentActivity?.state == .paused else { return }

        locationTracker.stop()
        dispatch(ActivityAction.activityDidFinish)
        healthTracker.stop()
    }

    private func watchResetActivity(state: AppState, dispatch: @escaping DispatchFunction) {
        guard state.currentActivity?.state == .finished else { return }

        dispatch(ActivityAction.activityDidReset)
        healthTracker.reset()
    }

    private func watchHealthTrackerDidStart(state: AppState, dispatch: @escaping DispatchFunction) {
        guard let activity = state.currentActivity,
            let startDate = activity.startDate else { return }
        healthTracker.startAccumulatingData(from: startDate)
    }

    private func watchHealthTrackerDidFinish(state: AppState, dispatch: @escaping DispatchFunction) {
        guard let activity = state.currentActivity,
            let startDate = activity.startDate,
            let endDate = activity.endDate else { return }
        healthTracker.save(from: startDate,
                           to: endDate,
                           distance: activity.totalDistance,
                           energy: activity.totalEnergyBurned,
                           locations: activity.locations)
    }
}

// MARK: - iPhone actions
extension ActivityActionRequest {
    private func phoneStartActivity(state: AppState, dispatch: @escaping DispatchFunction) {
        guard state.deviceState.locationPermission == .authorized else { return }
        remoteDevice.send(type: ActivityActionRequest.className,
                          data: [ActivityActionRequest.className: ActivityActionRequest.startActivity]) { _ in }
    }

    private func phonePauseActivity(state: AppState, dispatch: @escaping DispatchFunction) {
        remoteDevice.send(type: ActivityActionRequest.className,
                          data: [ActivityActionRequest.className: ActivityActionRequest.pauseActivity]) { _ in }
    }

    private func phoneFinishActivity(state: AppState, dispatch: @escaping DispatchFunction) {
        remoteDevice.send(type: ActivityActionRequest.className,
                          data: [ActivityActionRequest.className: ActivityActionRequest.finishActivity]) { _ in }
    }

    private func phoneResetActivity(state: AppState, dispatch: @escaping DispatchFunction) {
        remoteDevice.send(type: ActivityActionRequest.className,
                          data: [ActivityActionRequest.className: ActivityActionRequest.resetActivity]) { _ in }
    }
}

extension ActivityActionRequest: HasLocationTracker { }
extension ActivityActionRequest: HasHealthTracker { }
extension ActivityActionRequest: HasRemoteDevice { }
