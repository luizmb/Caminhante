@testable import CommonLibrary
import CoreLocation

func givenNoActivity(authorized: Bool = true, fromIPhone: Bool = false) -> AppState {
    var state = AppState()
    state.deviceState.locationPermission = authorized ? .authorized : .pending
    state.deviceState.deviceType = fromIPhone ? .iPhone : .appleWatch
    state.currentActivity = nil
    return state
}

func givenActivityInProgress(fromIPhone: Bool = false) -> AppState {
    var state = AppState()
    state.currentActivity = Activity(state: .inProgress, snapshotPoints: [])
    state.currentActivity!.startDate = Date(timeIntervalSinceReferenceDate: 0)
    state.deviceState.locationPermission = .authorized
    state.deviceState.deviceType = fromIPhone ? .iPhone : .appleWatch
    return state
}

func givenActivityPaused(fromIPhone: Bool = false) -> AppState {
    var state = AppState()
    state.currentActivity = Activity(state: .paused, snapshotPoints: [])
    state.currentActivity!.startDate = Date(timeIntervalSinceReferenceDate: 0)
    state.deviceState.locationPermission = .authorized
    state.deviceState.deviceType = fromIPhone ? .iPhone : .appleWatch
    return state
}

func givenActivityFinished(fromIPhone: Bool = false) -> AppState {
    var state = AppState()
    state.currentActivity = Activity(state: .finished, snapshotPoints: [])
    state.currentActivity!.startDate = Date(timeIntervalSinceReferenceDate: 0)
    state.currentActivity!.endDate = Date(timeIntervalSinceReferenceDate: 30)
    state.deviceState.locationPermission = .authorized
    state.deviceState.deviceType = fromIPhone ? .iPhone : .appleWatch
    return state
}
