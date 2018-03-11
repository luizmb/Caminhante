//
//  ActivityReducerTests.swift
//  CommonLibraryTests
//
//  Created by Luiz Rodrigo Martins Barbosa on 11.03.18.
//

@testable import CommonLibrary
import Foundation
import KleinKit
import Nimble

class LocationReducerTests: BaseTests {
    override func setUp() {
        super.setUp()
        injector.mapper.mapFactory(Date.self) { { Date(timeIntervalSinceReferenceDate: 4) } }
    }

    func testPermissionChangedToAuthorized() {
        var state = givenNoActivity()
        state.deviceState.locationPermission = .pending

        let sut = EntryPointReducer().reduce(state, action: LocationAction.permissionChanged(newPermission: .authorized))
        expect(sut.deviceState.locationPermission) == Permission.authorized
    }

    func testPermissionChangedToDenied() {
        var state = givenNoActivity()
        state.deviceState.healthPermission = .pending

        let sut = EntryPointReducer().reduce(state, action: LocationAction.permissionChanged(newPermission: .denied))
        expect(sut.deviceState.locationPermission) == Permission.denied
    }

    func testReceivedNewLocations() {
        let state = givenActivityInProgress()

        var sut = EntryPointReducer().reduce(state, action: LocationAction.receivedNewLocations([potsdam(), potsdam()]))
        expect(sut.currentActivity!.locations.count) == 2

        sut = EntryPointReducer().reduce(sut, action: LocationAction.receivedNewLocations([potsdam(), potsdam()]))
        expect(sut.currentActivity!.locations.count) == 4
    }

    func testReceivedNewSignificantLocation() {
        let state = givenActivityInProgress()

        let uuid = UUID()
        var sut = EntryPointReducer().reduce(state, action: LocationAction.receivedNewSignificantLocation(potsdam(),
                                                                                                          id: uuid,
                                                                                                          photoTask: AnyCancelableTask()))
        expect(sut.currentActivity!.snapshotPoints.count) == 1
        expect(sut.currentActivity!.snapshotPoints.first!.identifier) == uuid
        expect(sut.currentActivity!.snapshotPoints.first!.location.coordinate) == potsdam().coordinate
        expect(sut.currentActivity!.snapshotPoints.first!.photo.possibleValue()).to(beNil())

        let uuid2 = UUID()
        sut = EntryPointReducer().reduce(sut, action: LocationAction.receivedNewSignificantLocation(potsdam(),
                                                                                                    id: uuid2,
                                                                                                    photoTask: AnyCancelableTask()))
        expect(sut.currentActivity!.snapshotPoints.count) == 2
        expect(sut.currentActivity!.snapshotPoints.first!.identifier) == uuid2
        expect(sut.currentActivity!.snapshotPoints.first!.location.coordinate) == potsdam().coordinate
        expect(sut.currentActivity!.snapshotPoints.first!.photo.possibleValue()).to(beNil())
    }
}
