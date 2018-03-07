//
//  NavigationTests.swift
//  CommonLibraryTests
//
//  Created by Luiz Rodrigo Martins Barbosa on 07.03.18.
//

@testable import CommonLibrary
import CoreLocation
import Foundation
import Nimble

class NavigationTreeTests: BaseTests {
    func testRoot() {
        expect(NavigationTree.root().controller) == "ActivityControlsInterfaceController"
    }
}
