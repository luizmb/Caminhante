@testable import CommonLibrary
import Foundation
import KleinKit
import Nimble

class PhotoReducerTests: BaseTests {
    override func setUp() {
        super.setUp()
        injector.mapper.mapFactory(Date.self) { { Date(timeIntervalSinceReferenceDate: 4) } }
    }

    func testGotPhotoInformation() {
        let state = givenActivityInProgress()

        let uuid = UUID()
        var sut = EntryPointReducer().reduce(state, action: LocationAction.receivedNewSignificantLocation(potsdam(),
                                                                                                          id: uuid,
                                                                                                          photoTask: AnyCancelableTask()))
        sut = EntryPointReducer().reduce(sut, action: PhotoAction.gotPhotoInformation(.success(photoInformation), id: uuid))

        expect(sut.currentActivity!.snapshotPoints.count) == 1
        expect(sut.currentActivity!.snapshotPoints.first!.identifier) == uuid
        expect(sut.currentActivity!.snapshotPoints.first!.photo.possibleValue()) == photoInformation
    }

    func testGotPhotoInformationWrongId() {
        let state = givenActivityInProgress()

        let uuid = UUID()
        var sut = EntryPointReducer().reduce(state, action: LocationAction.receivedNewSignificantLocation(potsdam(),
                                                                                                          id: uuid,
                                                                                                          photoTask: AnyCancelableTask()))
        sut = EntryPointReducer().reduce(sut, action: PhotoAction.gotPhotoInformation(.success(photoInformation), id: UUID()))

        expect(sut.currentActivity!.snapshotPoints.count) == 1
        expect(sut.currentActivity!.snapshotPoints.first!.identifier) == uuid
        expect(sut.currentActivity!.snapshotPoints.first!.photo.possibleValue()).to(beNil())
    }

    func testGotPhotoData() {
        let state = givenActivityInProgress()

        let uuid = UUID()
        var sut = EntryPointReducer().reduce(state, action: LocationAction.receivedNewSignificantLocation(potsdam(),
                                                                                                          id: uuid,
                                                                                                          photoTask: AnyCancelableTask()))
        sut = EntryPointReducer().reduce(sut, action: PhotoAction.gotPhotoInformation(.success(photoInformation), id: uuid))
        sut = EntryPointReducer().reduce(sut, action: PhotoAction.gotPhotoData(.success(Data()), photoId: "a"))

        expect(sut.currentActivity!.snapshotPoints.count) == 1
        expect(sut.currentActivity!.snapshotPoints.first!.identifier) == uuid
        expect(sut.currentActivity!.snapshotPoints.first!.photo.possibleValue()) != photoInformation
        expect(sut.currentActivity!.snapshotPoints.first!.photo.possibleValue()!.image.possibleValue()).toNot(beNil())
        expect(sut.currentActivity!.snapshotPoints.first!.photo.possibleValue()!.image.possibleValue()?.count) == 0
    }

    func testGotPhotoDataWrongId() {
        let state = givenActivityInProgress()

        let uuid = UUID()
        var sut = EntryPointReducer().reduce(state, action: LocationAction.receivedNewSignificantLocation(potsdam(),
                                                                                                          id: uuid,
                                                                                                          photoTask: AnyCancelableTask()))
        sut = EntryPointReducer().reduce(sut, action: PhotoAction.gotPhotoInformation(.success(photoInformation), id: uuid))
        sut = EntryPointReducer().reduce(sut, action: PhotoAction.gotPhotoData(.success(Data()), photoId: "b"))

        expect(sut.currentActivity!.snapshotPoints.count) == 1
        expect(sut.currentActivity!.snapshotPoints.first!.identifier) == uuid
        expect(sut.currentActivity!.snapshotPoints.first!.photo.possibleValue()) == photoInformation
        expect(sut.currentActivity!.snapshotPoints.first!.photo.possibleValue()!.image.possibleValue()).to(beNil())
    }

    let photoInformation = PhotoInformation(id: "a", owner: "b", secret: "c", server: "d", farm: 5,
                                            title: "f", isPublic: true, isFriend: false, isFamily: false)
}
