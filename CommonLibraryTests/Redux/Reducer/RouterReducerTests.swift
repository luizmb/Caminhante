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

class RouterReducerTests: BaseTests {
    func testDidStart() {
        let state = givenNoActivity()

        let sut = EntryPointReducer().reduce(state, action: RouterAction.didStart(UIApplication.shared))
        expect(sut.deviceState.navigation) == NavigationTree.activityControls
    }

    func testDidNavigateToActivityControls() {
        let state = givenNoActivity()

        let sut = EntryPointReducer().reduce(state, action: RouterAction.didNavigate(.activityControls))
        expect(sut.deviceState.navigation) == NavigationTree.activityControls
    }

    func testDidNavigateToActivityPhotoStream() {
        let state = givenNoActivity()

        let sut = EntryPointReducer().reduce(state, action: RouterAction.didNavigate(.activityPhotoStream))
        expect(sut.deviceState.navigation) == NavigationTree.activityPhotoStream
    }
}
