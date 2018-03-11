import KleinKit
import Nimble
import XCTest

class BaseTests: XCTestCase {
    let injector = Injector.shared as! Injector

    override func setUp() {
        super.setUp()
        injector.mapper = .init()
    }

    override func tearDown() {
        super.tearDown()
        injector.mapper = .init()
    }

    func expectSuccessfulResult<T: Equatable>(result: Result<T>, valid: (T) -> Void) {
        switch result {
        case .success(let value):
            valid(value)
        default:
            fail()
        }
    }
}
