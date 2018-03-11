//
//  ActivityActionRequestTests.swift
//  CommonLibraryTests
//
//  Created by Luiz Rodrigo Martins Barbosa on 11.03.18.
//

@testable import CommonLibrary
import Foundation
import KleinKit
import Nimble

class ActivityActionRequestTests: BaseTests {
    let injector = Injector.shared as! Injector

    func testStartActivityFromIPhone() {
        let remoteDevice = mock()
        let state = givenNoActivity(authorized: true)
        var dispatchedActions: [Action] = []
        ActivityActionRequest.startActivity.execute(getState: { state },
                                                    dispatch: { dispatchedActions.append($0) },
                                                    dispatchAsync: { _ in })
        expect(remoteDevice.sendTypeDataCompletionCalls) == 1
        expect(remoteDevice.sendTypeDataCompletionTypes) == [ActivityActionRequest.className]
        expect(dispatchedActions.isEmpty) == true
        remoteDevice.sendTypeDataCompletionLastCompletion!(.success(()))
    }

    func testStartActivityFromIPhoneNotAuthorized() {
        let remoteDevice = mock()
        let state = givenNoActivity(authorized: false)
        var dispatchedActions: [Action] = []
        ActivityActionRequest.startActivity.execute(getState: { state },
                                                    dispatch: { dispatchedActions.append($0) },
                                                    dispatchAsync: { _ in })
        expect(remoteDevice.sendTypeDataCompletionCalls) == 0
        expect(remoteDevice.sendTypeDataCompletionTypes) == []
        expect(dispatchedActions.isEmpty) == true
    }

    func testResumeActivityFromIPhone() {
        let remoteDevice = mock()
        let state = givenActivityPaused()
        var dispatchedActions: [Action] = []
        ActivityActionRequest.startActivity.execute(getState: { state },
                                                    dispatch: { dispatchedActions.append($0) },
                                                    dispatchAsync: { _ in })
        expect(remoteDevice.sendTypeDataCompletionCalls) == 1
        expect(remoteDevice.sendTypeDataCompletionTypes) == [ActivityActionRequest.className]
        expect(dispatchedActions.isEmpty) == true
        remoteDevice.sendTypeDataCompletionLastCompletion!(.success(()))
    }

    func testPauseActivityFromIPhone() {
        let remoteDevice = mock()
        let state = givenActivityInProgress()
        var dispatchedActions: [Action] = []
        ActivityActionRequest.pauseActivity.execute(getState: { state },
                                                    dispatch: { dispatchedActions.append($0) },
                                                    dispatchAsync: { _ in })
        expect(remoteDevice.sendTypeDataCompletionCalls) == 1
        expect(remoteDevice.sendTypeDataCompletionTypes) == [ActivityActionRequest.className]
        expect(dispatchedActions.isEmpty) == true
        remoteDevice.sendTypeDataCompletionLastCompletion!(.success(()))
    }

    func testFinishActivityFromIPhone() {
        let remoteDevice = mock()
        let state = givenActivityInProgress()
        var dispatchedActions: [Action] = []
        ActivityActionRequest.finishActivity.execute(getState: { state },
                                                     dispatch: { dispatchedActions.append($0) },
                                                     dispatchAsync: { _ in })
        expect(remoteDevice.sendTypeDataCompletionCalls) == 1
        expect(remoteDevice.sendTypeDataCompletionTypes) == [ActivityActionRequest.className]
        expect(dispatchedActions.isEmpty) == true
        remoteDevice.sendTypeDataCompletionLastCompletion!(.success(()))
    }

    func testResetActivityFromIPhone() {
        let remoteDevice = mock()
        let state = givenActivityFinished()
        var dispatchedActions: [Action] = []
        ActivityActionRequest.resetActivity.execute(getState: { state },
                                                    dispatch: { dispatchedActions.append($0) },
                                                    dispatchAsync: { _ in })
        expect(remoteDevice.sendTypeDataCompletionCalls) == 1
        expect(remoteDevice.sendTypeDataCompletionTypes) == [ActivityActionRequest.className]
        expect(dispatchedActions.isEmpty) == true
        remoteDevice.sendTypeDataCompletionLastCompletion!(.success(()))
    }

    private func givenNoActivity(authorized: Bool) -> AppState {
        var state = AppState()
        state.deviceState.locationPermission = authorized ? .authorized : .pending
        state.deviceState.deviceType = .iPhone
        state.currentActivity = nil
        return state
    }

    private func givenActivityInProgress() -> AppState {
        var state = AppState()
        state.currentActivity = Activity(state: .inProgress, snapshotPoints: [])
        state.currentActivity!.startDate = Date(timeIntervalSinceReferenceDate: 0)
        state.deviceState.locationPermission = .authorized
        state.deviceState.deviceType = .iPhone
        return state
    }

    private func givenActivityPaused() -> AppState {
        var state = AppState()
        state.currentActivity = Activity(state: .paused, snapshotPoints: [])
        state.currentActivity!.startDate = Date(timeIntervalSinceReferenceDate: 0)
        state.deviceState.locationPermission = .authorized
        state.deviceState.deviceType = .iPhone
        return state
    }

    private func givenActivityFinished() -> AppState {
        var state = AppState()
        state.currentActivity = Activity(state: .finished, snapshotPoints: [])
        state.currentActivity!.startDate = Date(timeIntervalSinceReferenceDate: 0)
        state.currentActivity!.endDate = Date(timeIntervalSinceReferenceDate: 30)
        state.deviceState.locationPermission = .authorized
        state.deviceState.deviceType = .iPhone
        return state
    }

    private func mock() -> MockRemoteDevice {
        let remoteDevice = MockRemoteDevice()
        injector.mapper.mapSingleton(RemoteDevice.self) { remoteDevice }
        return remoteDevice
    }
}
