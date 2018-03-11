//
//  CommonLibraryTests.swift
//  CommonLibraryTests
//
//  Created by Luiz Rodrigo Martins Barbosa on 02.03.18.
//

import KleinKit
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
}
