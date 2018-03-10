//
//  AppStateTests.swift
//  CommonLibraryTests
//
//  Created by Luiz Rodrigo Martins Barbosa on 03.03.18.
//

@testable import CommonLibrary
import CoreLocation
import Foundation
import Nimble
import XCTest

class AppStateTests: BaseTests {
    let apple = CLLocation(coordinate: CLLocationCoordinate2D(latitude: 37.332_624_1,
                                                              longitude: -122.030_862_1),
                           altitude: CLLocationDistance(),
                           horizontalAccuracy: CLLocationAccuracy(),
                           verticalAccuracy: CLLocationAccuracy(),
                           timestamp: Date())

    let time = Date(timeIntervalSinceReferenceDate: 0)

    let uuid = UUID(uuidString: "9035C568-C8FF-415E-BAB4-03AB1BA9CE36")!

    var snapshotPoint: SnapshotPoint {
        return .init(identifier: uuid, location: apple, photo: .neverLoaded, time: time)
    }

    var activity: Activity {
        return .init(state: .paused, snapshotPoints: [snapshotPoint])
    }

    var deviceState: DeviceState {
        return .init(isInBackground: false, isActive: true, locationPermission: .authorized, healthPermission: .authorized)
    }

    var appState: AppState {
        return .init(currentActivity: activity, deviceState: deviceState)
    }

    func testEquatableTrue() {
        var appState2 = appState
        expect(appState2) == appState

        appState2 = appState
        appState2 = AppState(currentActivity: appState.currentActivity, deviceState: appState.deviceState)
        expect(appState2) == appState
    }
}
