@testable import CommonLibrary
import CoreLocation
import Foundation
import Nimble

class NavigationTreeTests: BaseTests {
    func testRoot() {
        expect(NavigationTree.root().controller) == "ActivityControlsInterfaceController"
    }
}
