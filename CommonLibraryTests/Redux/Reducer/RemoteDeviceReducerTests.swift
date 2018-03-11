@testable import CommonLibrary
import Foundation
import KleinKit
import Nimble

class RemoteDeviceReducerTests: BaseTests {
    func testActivationCompleteWithSuccess() {
        let state = givenNoActivity()

        let sut = EntryPointReducer().reduce(state, action: RemoteDeviceAction.activationComplete(success: true))

        expect(sut.deviceState.counterPartConnection).to(beTrue())
    }

    func testActivationCompleteWithFailure() {
        let state = givenNoActivity()

        let sut = EntryPointReducer().reduce(state, action: RemoteDeviceAction.activationComplete(success: false))

        expect(sut.deviceState.counterPartConnection).to(beFalse())
    }

    func testReachabilityCompleteWithSuccess() {
        let state = givenNoActivity()

        let sut = EntryPointReducer().reduce(state, action: RemoteDeviceAction.reachabilityChanged(isReachable: true))

        expect(sut.deviceState.counterPartReachable).to(beTrue())
    }

    func testReachabilityCompleteWithFailure() {
        let state = givenNoActivity()

        let sut = EntryPointReducer().reduce(state, action: RemoteDeviceAction.reachabilityChanged(isReachable: false))

        expect(sut.deviceState.counterPartReachable).to(beFalse())
    }
}
