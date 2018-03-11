//
//  MockRemoteDevice.swift
//  CommonLibraryTests
//
//  Created by Luiz Rodrigo Martins Barbosa on 11.03.18.
//

@testable import CommonLibrary
import Foundation
import KleinKit

class MockRemoteDevice: RemoteDevice {
    var activateSessionCalls = 0
    func activateSession() {
        activateSessionCalls += 1
    }

    var updateStateTypeDataCalls = 0
    func updateState<T>(type: String, data: T)
        where T: Decodable, T: Encodable {
        updateStateTypeDataCalls += 1
    }

    var sendTypeDataCalls = 0
    var sendTypeDataTypes: [String] = []
    func send<T>(type: String, data: T)
        where T: Decodable, T: Encodable {
        sendTypeDataCalls += 1
        sendTypeDataTypes += [type]
    }

    var sendTypeDataCompletionCalls = 0
    var sendTypeDataCompletionTypes: [String] = []
    var sendTypeDataCompletionLastCompletion: ((Result<Void>) -> Void)?
    func send<T>(type: String,
                 data: T,
                 completion: @escaping (Result<Void>) -> Void) where T: Decodable, T: Encodable {
        sendTypeDataCompletionCalls += 1
        sendTypeDataCompletionTypes += [type]
        sendTypeDataCompletionLastCompletion = completion
    }
}
