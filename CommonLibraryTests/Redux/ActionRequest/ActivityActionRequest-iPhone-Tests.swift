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
    func testStartActivityFromIPhone() {
        let remoteDevice = mock()
        let state = givenNoActivity(authorized: true, fromIPhone: true)
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
        let state = givenNoActivity(authorized: false, fromIPhone: true)
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
        let state = givenActivityPaused(fromIPhone: true)
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
        let state = givenActivityInProgress(fromIPhone: true)
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
        let state = givenActivityInProgress(fromIPhone: true)
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
        let state = givenActivityFinished(fromIPhone: true)
        var dispatchedActions: [Action] = []
        ActivityActionRequest.resetActivity.execute(getState: { state },
                                                    dispatch: { dispatchedActions.append($0) },
                                                    dispatchAsync: { _ in })
        expect(remoteDevice.sendTypeDataCompletionCalls) == 1
        expect(remoteDevice.sendTypeDataCompletionTypes) == [ActivityActionRequest.className]
        expect(dispatchedActions.isEmpty) == true
        remoteDevice.sendTypeDataCompletionLastCompletion!(.success(()))
    }

    private func mock() -> MockRemoteDevice {
        let remoteDevice = MockRemoteDevice()
        injector.mapper.mapSingleton(RemoteDevice.self) { remoteDevice }
        return remoteDevice
    }
}
