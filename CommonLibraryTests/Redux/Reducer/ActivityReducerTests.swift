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

class ActivityReducerTests: BaseTests {
    override func setUp() {
        super.setUp()
        injector.mapper.mapFactory(Date.self) { { Date(timeIntervalSinceReferenceDate: 4) } }
    }

    func testActivityDidStartReducer() {
        let state = givenNoActivity(authorized: true)

        let sut = EntryPointReducer().reduce(state, action: ActivityAction.activityDidStart)
        expect(sut.currentActivity).toNot(beNil())
        expect(sut.currentActivity!.state) == ActivityState.inProgress
        expect(sut.currentActivity!.startDate) == Date(timeIntervalSinceReferenceDate: 4)
    }

    func testActivityDidResumeReducer() {
        var state = givenActivityPaused()
        let dateWhenStarted = Date(timeIntervalSinceReferenceDate: 99)
        state.currentActivity!.startDate = dateWhenStarted

        let sut = EntryPointReducer().reduce(state, action: ActivityAction.activityDidStart)
        expect(sut.currentActivity).toNot(beNil())
        expect(sut.currentActivity!.state) == ActivityState.inProgress
        expect(sut.currentActivity!.startDate) == dateWhenStarted
    }

    func testActivityDidPauseReducer() {
        let state = givenActivityInProgress()

        let sut = EntryPointReducer().reduce(state, action: ActivityAction.activityDidPause)
        expect(sut.currentActivity).toNot(beNil())
        expect(sut.currentActivity!.state) == ActivityState.paused
    }

    func testActivityDidFinishReducer() {
        let state = givenActivityInProgress()

        let sut = EntryPointReducer().reduce(state, action: ActivityAction.activityDidFinish)
        expect(sut.currentActivity).toNot(beNil())
        expect(sut.currentActivity!.state) == ActivityState.finished
        expect(sut.currentActivity!.startDate) == Date(timeIntervalSinceReferenceDate: 0)
        expect(sut.currentActivity!.endDate) == Date(timeIntervalSinceReferenceDate: 4)
    }

    func testActivityDidResetReducer() {
        let state = givenActivityFinished()

        let sut = EntryPointReducer().reduce(state, action: ActivityAction.activityDidReset)
        expect(sut.currentActivity).to(beNil())
    }

    func testActivityDidWalkDistanceReducer() {
        let state = givenActivityInProgress()

        var sut = EntryPointReducer().reduce(state, action: ActivityAction.healthTrackerDidWalkDistance(.init(value: 5, unit: .meters)))
        expect(sut.currentActivity!.totalDistance.converted(to: .meters).value).to(beCloseTo(5))

        sut = EntryPointReducer().reduce(sut, action: ActivityAction.healthTrackerDidWalkDistance(.init(value: 9, unit: .meters)))
        expect(sut.currentActivity!.totalDistance.converted(to: .meters).value).to(beCloseTo(14))

        sut = EntryPointReducer().reduce(sut, action: ActivityAction.healthTrackerDidWalkDistance(.init(value: 1.5, unit: .kilometers)))
        expect(sut.currentActivity!.totalDistance.converted(to: .meters).value).to(beCloseTo(1_514))
    }

    func testActivityDidBurnEnergyReducer() {
        let state = givenActivityInProgress()

        var sut = EntryPointReducer().reduce(state, action: ActivityAction.healthTrackerDidBurnEnergy(.init(value: 5, unit: .calories)))
        expect(sut.currentActivity!.totalEnergyBurned.converted(to: .calories).value).to(beCloseTo(5))

        sut = EntryPointReducer().reduce(sut, action: ActivityAction.healthTrackerDidBurnEnergy(.init(value: 9, unit: .calories)))
        expect(sut.currentActivity!.totalEnergyBurned.converted(to: .calories).value).to(beCloseTo(14))

        sut = EntryPointReducer().reduce(sut, action: ActivityAction.healthTrackerDidBurnEnergy(.init(value: 1.5, unit: .kilocalories)))
        expect(sut.currentActivity!.totalEnergyBurned.converted(to: .calories).value).to(beCloseTo(1_514))
    }

}
