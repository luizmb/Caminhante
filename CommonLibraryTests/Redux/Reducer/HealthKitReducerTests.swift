@testable import CommonLibrary
import Foundation
import KleinKit
import Nimble

class HealthKitReducerTests: BaseTests {
    func testPermissionChangedToAuthorized() {
        var state = givenNoActivity()
        state.deviceState.healthPermission = .pending

        let sut = EntryPointReducer().reduce(state, action: HealthKitAction.permissionChanged(newPermission: .authorized))
        expect(sut.deviceState.healthPermission) == Permission.authorized
    }

    func testPermissionChangedToDenied() {
        var state = givenNoActivity()
        state.deviceState.healthPermission = .pending

        let sut = EntryPointReducer().reduce(state, action: HealthKitAction.permissionChanged(newPermission: .denied))
        expect(sut.deviceState.healthPermission) == Permission.denied
    }
}
