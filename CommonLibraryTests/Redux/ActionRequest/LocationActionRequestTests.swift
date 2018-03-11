@testable import CommonLibrary
import CoreLocation
import Foundation
import KleinKit
import Nimble

class LocationActionRequestTests: BaseTests {
    func testEvaluateNewLocations() {
        let healthTracker = mock()
        let state = givenActivityInProgress()
        var dispatchedActions: [Action] = []
        var dispatchedAsync = [AnyActionAsync<AppState>]()

        LocationActionRequest
            .evaluateNewLocations([potsdam()])
            .execute(getState: { state },
                     dispatch: { dispatchedActions.append($0) },
                     dispatchAsync: { dispatchedAsync.append($0) })

        expect(healthTracker.appendLocationsCalls) == 1
        expect(healthTracker.locations.count) == 1
        expect(healthTracker.locations.first!.coordinate) == potsdam().coordinate
        expect(dispatchedActions.count) == 1
        switch dispatchedActions[0] as! LocationAction {
        case .receivedNewLocations(let locations):
            expect(locations.count) == 1
            expect(locations.first!.coordinate) == potsdam().coordinate
        default:
            fail()
        }
        expect(dispatchedAsync.count) == 1
    }

    func testEvaluateNewLocationsNoActivity() {
        let healthTracker = mock()
        let state = givenNoActivity(authorized: true)
        var dispatchedActions: [Action] = []
        var dispatchedAsync = [AnyActionAsync<AppState>]()

        LocationActionRequest
            .evaluateNewLocations([potsdam()])
            .execute(getState: { state },
                     dispatch: { dispatchedActions.append($0) },
                     dispatchAsync: { dispatchedAsync.append($0) })

        expect(healthTracker.appendLocationsCalls) == 0
        expect(healthTracker.locations.count) == 0
        expect(dispatchedActions.count) == 0
        expect(dispatchedAsync.count) == 0
    }

    func testEvaluateNewLocationsEmpty() {
        let healthTracker = mock()
        let state = givenActivityInProgress()
        var dispatchedActions: [Action] = []
        var dispatchedAsync = [AnyActionAsync<AppState>]()

        LocationActionRequest
            .evaluateNewLocations([])
            .execute(getState: { state },
                     dispatch: { dispatchedActions.append($0) },
                     dispatchAsync: { dispatchedAsync.append($0) })

        expect(healthTracker.appendLocationsCalls) == 0
        expect(healthTracker.locations.count) == 0
        expect(dispatchedActions.count) == 0
        expect(dispatchedAsync.count) == 0
    }

    func testEvaluateNewLocationsNotRelevant() {
        let healthTracker = mock()
        var state = givenActivityInProgress()
        state.currentActivity!.snapshotPoints.append(SnapshotPoint(identifier: UUID(),
                                                                   location: potsdam(),
                                                                   photo: .neverLoaded,
                                                                   time: Date()))
        var dispatchedActions: [Action] = []
        var dispatchedAsync = [AnyActionAsync<AppState>]()

        LocationActionRequest
            .evaluateNewLocations([potsdam()])
            .execute(getState: { state },
                     dispatch: { dispatchedActions.append($0) },
                     dispatchAsync: { dispatchedAsync.append($0) })

        expect(healthTracker.appendLocationsCalls) == 1
        expect(healthTracker.locations.count) == 1
        expect(healthTracker.locations.first!.coordinate) == potsdam().coordinate
        expect(dispatchedActions.count) == 1
        switch dispatchedActions[0] as! LocationAction {
        case .receivedNewLocations(let locations):
            expect(locations.count) == 1
            expect(locations.first!.coordinate) == potsdam().coordinate
        default:
            fail()
        }
        expect(dispatchedAsync.count) == 0
    }

    private func mock() -> MockHealthTracker {
        let healthTracker = MockHealthTracker()
        injector.mapper.mapSingleton(HealthTracker.self) { healthTracker }
        return healthTracker
    }
}
