@testable import CommonLibrary
import CoreLocation
import Foundation
import KleinKit

class MockHealthTracker: HealthTracker {
    var requestAuthorizationCalls = 0
    func requestAuthorization() {
        requestAuthorizationCalls += 1
    }

    var startCalls = 0
    func start() {
        startCalls += 1
    }

    var pauseCalls = 0
    func pause() {
        pauseCalls += 1
    }

    var resumeCalls = 0
    func resume() {
        resumeCalls += 1
    }

    var stopCalls = 0
    func stop() {
        stopCalls += 1
    }

    var resetCalls = 0
    func reset() {
        resetCalls += 1
    }

    var saveCalls = 0
    func save(from startDate: Date,
              to endDate: Date,
              distance: Measurement<UnitLength>,
              energy: Measurement<UnitEnergy>,
              locations: [CLLocation]) {
        saveCalls += 1
    }

    var startAccumulatingDataCalls = 0
    func startAccumulatingData(from startDate: Date) {
        startAccumulatingDataCalls += 1
    }

    var appendLocationsCalls = 0
    var locations: [CLLocation] = []
    func appendLocations(_ locations: [CLLocation]) {
        appendLocationsCalls += 1
        self.locations += locations
    }
}
