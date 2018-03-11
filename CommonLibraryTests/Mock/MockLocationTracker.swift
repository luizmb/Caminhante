@testable import CommonLibrary
import CoreLocation
import Foundation
import KleinKit

class MockLocationTracker: LocationTracker {
    var requestAuthorizationCalls = 0
    func requestAuthorization() {
        requestAuthorizationCalls += 1
    }

    var isAllowed: Bool = true

    var startCalls = 0
    func start() {
        startCalls += 1
    }

    var stopCalls = 0
    func stop() {
        stopCalls += 1
    }
}

func potsdam() -> CLLocation {
    return .init(latitude: 52.399_591, longitude: 13.045_899_9)
}
