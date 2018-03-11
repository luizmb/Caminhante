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

extension ActivityActionRequestTests {
    func testStartActivityFromWatch() {
        let (locationTracker, healthTracker) = mock()
        let state = givenNoActivity(authorized: true)
        var dispatchedActions: [Action] = []
        ActivityActionRequest.startActivity.execute(getState: { state },
                                                    dispatch: { dispatchedActions.append($0) },
                                                    dispatchAsync: { _ in })
        expect(locationTracker.startCalls) == 1
        expect(healthTracker.startCalls) == 1
        expect(healthTracker.resumeCalls) == 0
        expect(dispatchedActions.count) == 2
        switch dispatchedActions[0] as! ActivityAction {
        case .activityDidStart:
            break
        default:
            fail()
        }
        switch dispatchedActions[1] as! RouterAction {
        case .didNavigate(let destination):
            expect(destination) == NavigationTree.activityPhotoStream
        default:
            fail()
        }
    }

    func testStartActivityFromWatchNotAuthorized() {
        let (locationTracker, healthTracker) = mock()
        let state = givenNoActivity(authorized: false)
        var dispatchedActions: [Action] = []
        ActivityActionRequest.startActivity.execute(getState: { state },
                                                    dispatch: { dispatchedActions.append($0) },
                                                    dispatchAsync: { _ in })
        expect(locationTracker.startCalls) == 0
        expect(healthTracker.startCalls) == 0
        expect(healthTracker.resumeCalls) == 0
        expect(dispatchedActions.count) == 0
    }

    func testResumeActivityFromWatch() {
        let (locationTracker, healthTracker) = mock()
        let state = givenActivityPaused()
        var dispatchedActions: [Action] = []
        ActivityActionRequest.startActivity.execute(getState: { state },
                                                    dispatch: { dispatchedActions.append($0) },
                                                    dispatchAsync: { _ in })
        expect(locationTracker.startCalls) == 1
        expect(healthTracker.startCalls) == 0
        expect(healthTracker.resumeCalls) == 1
        expect(dispatchedActions.count) == 2
        switch dispatchedActions[0] as! ActivityAction {
        case .activityDidStart:
            break
        default:
            fail()
        }
        switch dispatchedActions[1] as! RouterAction {
        case .didNavigate(let destination):
            expect(destination) == NavigationTree.activityPhotoStream
        default:
            fail()
        }
    }

    func testPauseActivityFromWatch() {
        let (locationTracker, healthTracker) = mock()
        let state = givenActivityInProgress()
        var dispatchedActions: [Action] = []
        ActivityActionRequest.pauseActivity.execute(getState: { state },
                                                    dispatch: { dispatchedActions.append($0) },
                                                    dispatchAsync: { _ in })
        expect(locationTracker.stopCalls) == 1
        expect(healthTracker.pauseCalls) == 1
        expect(healthTracker.stopCalls) == 0
        expect(dispatchedActions.count) == 1
        switch dispatchedActions[0] as! ActivityAction {
        case .activityDidPause:
            break
        default:
            fail()
        }
    }

    func testFinishActivityFromWatch() {
        let (locationTracker, healthTracker) = mock()
        let state = givenActivityInProgress()
        var dispatchedActions: [Action] = []
        ActivityActionRequest.finishActivity.execute(getState: { state },
                                                     dispatch: { dispatchedActions.append($0) },
                                                     dispatchAsync: { _ in })
        expect(locationTracker.stopCalls) == 1
        expect(healthTracker.pauseCalls) == 0
        expect(healthTracker.stopCalls) == 1
        expect(dispatchedActions.count) == 1
        switch dispatchedActions[0] as! ActivityAction {
        case .activityDidFinish:
            break
        default:
            fail()
        }
    }

    func testFinishPausedActivityFromWatch() {
        let (locationTracker, healthTracker) = mock()
        let state = givenActivityPaused()
        var dispatchedActions: [Action] = []
        ActivityActionRequest.finishActivity.execute(getState: { state },
                                                     dispatch: { dispatchedActions.append($0) },
                                                     dispatchAsync: { _ in })
        expect(locationTracker.stopCalls) == 1
        expect(healthTracker.pauseCalls) == 0
        expect(healthTracker.stopCalls) == 1
        expect(dispatchedActions.count) == 1
        switch dispatchedActions[0] as! ActivityAction {
        case .activityDidFinish:
            break
        default:
            fail()
        }
    }

    func testResetActivityFromWatch() {
        let (locationTracker, healthTracker) = mock()
        let state = givenActivityFinished()
        var dispatchedActions: [Action] = []
        ActivityActionRequest.resetActivity.execute(getState: { state },
                                                    dispatch: { dispatchedActions.append($0) },
                                                    dispatchAsync: { _ in })
        expect(locationTracker.stopCalls) == 0
        expect(healthTracker.pauseCalls) == 0
        expect(healthTracker.stopCalls) == 0
        expect(healthTracker.resetCalls) == 1
        expect(dispatchedActions.count) == 1
        switch dispatchedActions[0] as! ActivityAction {
        case .activityDidReset:
            break
        default:
            fail()
        }
    }

    func testHealthTrackerDidStart() {
        let (_, healthTracker) = mock()
        let state = givenActivityInProgress()
        var dispatchedActions: [Action] = []
        ActivityActionRequest.healthTrackerDidStart.execute(getState: { state },
                                                            dispatch: { dispatchedActions.append($0) },
                                                            dispatchAsync: { _ in })
        expect(healthTracker.startAccumulatingDataCalls) == 1
    }

    func testHealthTrackerDidStartNoActivity() {
        let (_, healthTracker) = mock()
        let state = givenNoActivity(authorized: true)
        var dispatchedActions: [Action] = []
        ActivityActionRequest.healthTrackerDidStart.execute(getState: { state },
                                                            dispatch: { dispatchedActions.append($0) },
                                                            dispatchAsync: { _ in })
        expect(healthTracker.startAccumulatingDataCalls) == 0
    }

    func testHealthTrackerDidFinish() {
        let (_, healthTracker) = mock()
        let state = givenActivityFinished()
        var dispatchedActions: [Action] = []
        ActivityActionRequest.healthTrackerDidFinish.execute(getState: { state },
                                                             dispatch: { dispatchedActions.append($0) },
                                                             dispatchAsync: { _ in })
        expect(healthTracker.saveCalls) == 1
    }

    func testHealthTrackerDidFinishRunningActivity() {
        let (_, healthTracker) = mock()
        let state = givenActivityInProgress()
        var dispatchedActions: [Action] = []
        ActivityActionRequest.healthTrackerDidFinish.execute(getState: { state },
                                                             dispatch: { dispatchedActions.append($0) },
                                                             dispatchAsync: { _ in })
        expect(healthTracker.saveCalls) == 0
    }

    private func mock() -> (MockLocationTracker, MockHealthTracker) {
        let locationTracker = MockLocationTracker()
        let healthTracker = MockHealthTracker()
        injector.mapper.mapSingleton(LocationTracker.self) { locationTracker }
        injector.mapper.mapSingleton(HealthTracker.self) { healthTracker }
        return (locationTracker, healthTracker)
    }
}
