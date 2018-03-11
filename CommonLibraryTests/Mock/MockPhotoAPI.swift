//
//  MockPhotoAPI.swift
//  CommonLibraryTests
//
//  Created by Luiz Rodrigo Martins Barbosa on 11.03.18.
//

@testable import CommonLibrary
import Foundation
import KleinKit

class AnyCancelableTask: CancelableTask {
    var cancelCalls = 0
    func cancel() {
        cancelCalls += 1
    }
}

class MockPhotoAPI: PhotoAPI {
    var requestCalls = 0
    var requestEndpoint: PhotoServiceEndpoint?
    var requestCompletion: ((Result<Data>) -> Void)?
    var requestReturn: CancelableTask = AnyCancelableTask()
    func request(_ endpoint: PhotoServiceEndpoint,
                 completion: @escaping (Result<Data>) -> Void) -> CancelableTask {
        requestCalls += 1
        requestEndpoint = endpoint
        requestCompletion = completion
        return requestReturn
    }
}
