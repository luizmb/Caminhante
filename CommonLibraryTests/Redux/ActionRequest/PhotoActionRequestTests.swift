//
//  PhotoActionRequestTests.swift
//  CommonLibraryTests
//
//  Created by Luiz Rodrigo Martins Barbosa on 11.03.18.
//

@testable import CommonLibrary
import Foundation
import KleinKit
import Nimble

class PhotoActionRequestTests: BaseTests {
    func testStartSnapshotProcessPhotoInformationRequest() {
        let photoAPI = mock()
        let state = givenActivityInProgress()

        var dispatchedActions: [Action] = []
        PhotoActionRequest
            .startSnapshotProcess(newLocation: potsdam())
            .execute(getState: { state },
                     dispatch: { dispatchedActions.append($0) },
                     dispatchAsync: { _ in })

        expect(dispatchedActions.count) == 1
        switch dispatchedActions[0] as! LocationAction {
        case .receivedNewSignificantLocation(let location, _, _):
            expect(location.coordinate) == potsdam().coordinate
        default:
            fail()
        }

        expect(photoAPI.requestCalls) == 1
        switch photoAPI.requestEndpoint! {
        case .publicPhotosNearby(let location, let page, let pageSize):
            expect(location) == potsdam().coordinate
            expect(page) == 1
            expect(pageSize) == 20
        default: fail()
        }
    }

    func testStartSnapshotProcessPhotoInformationResult() {
        let photoAPI = mock()
        let state = givenActivityInProgress()

        var dispatchedActions: [Action] = []
        PhotoActionRequest
            .startSnapshotProcess(newLocation: potsdam())
            .execute(getState: { state },
                     dispatch: { dispatchedActions.append($0) },
                     dispatchAsync: { _ in })

        photoAPI.requestCompletion!(.success(jsonSuccessfulResult.data(using: .utf8)!))
        expect(dispatchedActions.count) == 2
        switch dispatchedActions[1] as! PhotoAction {
        case .gotPhotoInformation(let photoInformationResult, _):
            expectSuccessfulResult(result: photoInformationResult,
                                   valid: expectFirstPhoto)
        default:
            fail()
        }

        expect(photoAPI.requestCalls) == 2
        switch photoAPI.requestEndpoint! {
        case .publicPhoto(let url):
            expect(url.absoluteString) == "https://farm5.staticflickr.com/4770/26555751578_13fa595c69_n.jpg"
        default: fail()
        }
    }

    func testStartSnapshotProcessPhotoDataResult() {
        let photoAPI = mock()
        let state = givenActivityInProgress()

        var dispatchedActions: [Action] = []
        PhotoActionRequest
            .startSnapshotProcess(newLocation: potsdam())
            .execute(getState: { state },
                     dispatch: { dispatchedActions.append($0) },
                     dispatchAsync: { _ in })

        photoAPI.requestCompletion!(.success(jsonSuccessfulResult.data(using: .utf8)!))
        photoAPI.requestCompletion!(.success(fakePhoto))
        expect(dispatchedActions.count) == 3

        switch dispatchedActions[2] as! PhotoAction {
        case .gotPhotoData(let result, _):
            expectSuccessfulResult(result: result,
                                   valid: { expect($0.count) == 3 })
        default:
            fail()
        }
    }

    private func expectFirstPhoto(_ photoInformation: PhotoInformation) {
        expect(photoInformation.id) == "26555751578"
        expect(photoInformation.owner) == "9187590@N04"
        expect(photoInformation.secret) == "13fa595c69"
        expect(photoInformation.server) == "4770"
        expect(photoInformation.farm) == 5
        expect(photoInformation.title) == "20180218_160940"
        expect(photoInformation.isPublic).to(beTrue())
        expect(photoInformation.isFriend).to(beFalse())
        expect(photoInformation.isFamily).to(beFalse())
    }

    private func mock() -> MockPhotoAPI {
        let photoAPI = MockPhotoAPI()
        injector.mapper.mapSingleton(PhotoAPI.self) { photoAPI }
        return photoAPI
    }

    private var fakePhoto: Data {
        return Data(bytes: [0x00, 0x01, 0x02])
    }
}
