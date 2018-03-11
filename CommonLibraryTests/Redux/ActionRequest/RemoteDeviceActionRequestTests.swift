//
//  RemoteDeviceActionRequestTests.swift
//  CommonLibraryTests
//
//  Created by Luiz Rodrigo Martins Barbosa on 11.03.18.
//

@testable import CommonLibrary
import Foundation
import KleinKit
import Nimble

class RemoteDeviceActionRequestTests: BaseTests {
    func testHandleUpdatedStateToPause() {
        let state = AppState()
        var dispatchedActions: [Action] = []
        var dispatchedAsync: [AnyActionAsync<AppState>] = []
        RemoteDeviceActionRequest
            .handleUpdatedState(["ActivityState": "{\"ActivityState\":\(ActivityState.paused.rawValue)}".data(using: .utf8)!])
            .execute(getState: { state },
                     dispatch: { dispatchedActions.append($0) },
                     dispatchAsync: { dispatchedAsync.append($0) })

        expect(dispatchedAsync.count) == 0
        expect(dispatchedActions.count) == 1
        switch dispatchedActions[0] as! ActivityAction {
        case .activityDidPause: break
        default: fail()
        }
    }

    func testHandleUpdatedStateToStart() {
        let state = AppState()
        var dispatchedActions: [Action] = []
        var dispatchedAsync: [AnyActionAsync<AppState>] = []
        RemoteDeviceActionRequest
            .handleUpdatedState(["ActivityState": "{\"ActivityState\":\(ActivityState.inProgress.rawValue)}".data(using: .utf8)!])
            .execute(getState: { state },
                     dispatch: { dispatchedActions.append($0) },
                     dispatchAsync: { dispatchedAsync.append($0) })

        expect(dispatchedAsync.count) == 0
        expect(dispatchedActions.count) == 1
        switch dispatchedActions[0] as! ActivityAction {
        case .activityDidStart: break
        default: fail()
        }
    }

    func testHandleUpdatedStateToFinish() {
        let state = AppState()
        var dispatchedActions: [Action] = []
        var dispatchedAsync: [AnyActionAsync<AppState>] = []
        RemoteDeviceActionRequest
            .handleUpdatedState(["ActivityState": "{\"ActivityState\":\(ActivityState.finished.rawValue)}".data(using: .utf8)!])
            .execute(getState: { state },
                     dispatch: { dispatchedActions.append($0) },
                     dispatchAsync: { dispatchedAsync.append($0) })

        expect(dispatchedAsync.count) == 0
        expect(dispatchedActions.count) == 1
        switch dispatchedActions[0] as! ActivityAction {
        case .activityDidFinish: break
        default: fail()
        }
    }

    func testHandleUpdatedStateToNil() {
        let state = AppState()
        var dispatchedActions: [Action] = []
        var dispatchedAsync: [AnyActionAsync<AppState>] = []
        RemoteDeviceActionRequest
            .handleUpdatedState(["ActivityState": "{\"ActivityState\":null}".data(using: .utf8)!])
            .execute(getState: { state },
                     dispatch: { dispatchedActions.append($0) },
                     dispatchAsync: { dispatchedAsync.append($0) })

        expect(dispatchedAsync.count) == 0
        expect(dispatchedActions.count) == 1
        switch dispatchedActions[0] as! ActivityAction {
        case .activityDidReset: break
        default: fail()
        }
    }

    func testHandleUpdatedStateToInvalidJson() {
        let state = AppState()
        var dispatchedActions: [Action] = []
        var dispatchedAsync: [AnyActionAsync<AppState>] = []
        RemoteDeviceActionRequest
            .handleUpdatedState(["ActivityState": "{\"ActivitState\":null}".data(using: .utf8)!])
            .execute(getState: { state },
                     dispatch: { dispatchedActions.append($0) },
                     dispatchAsync: { dispatchedAsync.append($0) })

        expect(dispatchedAsync.count) == 0
        expect(dispatchedActions.count) == 0
    }

    func testHandleData() {
        let state = AppState()
        var dispatchedActions: [Action] = []
        var dispatchedAsync: [AnyActionAsync<AppState>] = []
        RemoteDeviceActionRequest
            .handleData([:])
            .execute(getState: { state },
                     dispatch: { dispatchedActions.append($0) },
                     dispatchAsync: { dispatchedAsync.append($0) })

        expect(dispatchedAsync.count) == 0
        expect(dispatchedActions.count) == 0
    }

    func testHandleDataWithCompletion() {
        let state = AppState()
        var dispatchedActions: [Action] = []
        var dispatchedAsync: [AnyActionAsync<AppState>] = []
        var completionCalled = 0
        let completion: ([String: Any]) -> Void = { _ in completionCalled += 1 }
        let data = ["ActivityActionRequest": "{\"ActivityActionRequest\":\(ActivityActionRequest.startActivity.rawValue)}".data(using: .utf8)!]
        RemoteDeviceActionRequest
            .handleDataWithCompletion(data,
                                      completion: completion)
            .execute(getState: { state },
                     dispatch: { dispatchedActions.append($0) },
                     dispatchAsync: { dispatchedAsync.append($0) })

        expect(dispatchedActions.count) == 0
        expect(completionCalled) == 1
        expect(dispatchedAsync.count) == 1
    }

    func testHandleDataWithCompletionError() {
        let state = AppState()
        var dispatchedActions: [Action] = []
        var dispatchedAsync: [AnyActionAsync<AppState>] = []
        var completionCalled = 0
        let completion: ([String: Any]) -> Void = { _ in completionCalled += 1 }
        let data = ["ActivityActionReques": "{\"ActivityActionRequest\":\(ActivityActionRequest.startActivity.rawValue)}".data(using: .utf8)!]
        RemoteDeviceActionRequest
            .handleDataWithCompletion(data,
                                      completion: completion)
            .execute(getState: { state },
                     dispatch: { dispatchedActions.append($0) },
                     dispatchAsync: { dispatchedAsync.append($0) })

        expect(dispatchedActions.count) == 0
        expect(completionCalled) == 1
        expect(dispatchedAsync.count) == 0
    }
}
