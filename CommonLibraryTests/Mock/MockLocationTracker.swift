//
//  MockLocationTracker.swift
//  CommonLibraryTests
//
//  Created by Luiz Rodrigo Martins Barbosa on 11.03.18.
//

@testable import CommonLibrary
import Foundation
import KleinKit

class MockLocationTracker: LocationTracker {
    var requestAuthorizationCalls = 0
    func requestAuthorization() {
        requestAuthorizationCalls += 1
    }

    var isAllowed: Bool = true
    
    var startCalls = 0
    func start() {
        startCalls += 1
    }
    
    var stopCalls = 0
    func stop() {
        stopCalls += 1
    }
}
