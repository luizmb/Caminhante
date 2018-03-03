//
//  PhotoDecodableTests.swift
//  CommonLibraryTests
//
//  Created by Luiz Rodrigo Martins Barbosa on 03.03.18.
//

@testable import CommonLibrary
import Foundation
import Nimble
import XCTest

class PhotoDecodableTests: BaseTests {
    let json = """
                {
                    "photos": {
                        "page": 1,
                        "pages": 540,
                        "perpage": 1,
                        "total": "540",
                        "photo": [
                            {
                                "id": "28062536909",
                                "owner": "142801205@N06",
                                "secret": "dbd6a30d6c",
                                "server": "4610",
                                "farm": 5,
                                "title": "Machnower Schleuse",
                                "ispublic": 1,
                                "isfriend": 0,
                                "isfamily": 0
                            }
                        ]
                    },
                    "stat": "ok"
                }
                """

    let jsonError = """
                    {
                        "stat": "fail",
                        "code": 112,
                        "message": "Method \\"flickr.phtos.search\\" not found"
                    }
                    """

    func testJsonDecoder() {
        let photoResponse = try! JSONDecoder().decode(PhotoResponse.self, from: json.data(using: .utf8)!)
        expect(photoResponse.status) == PhotoResponseStatus.success
        expect(photoResponse.responsePage).toNot(beNil())
        expect(photoResponse.code).to(beNil())
        expect(photoResponse.message).to(beNil())

        let responsePage = photoResponse.responsePage!
        expect(responsePage.currentPage) == 1
        expect(responsePage.pageCount) == 540
        expect(responsePage.pageSize) == 1
        expect(responsePage.filterCount) == 540
        expect(responsePage.photos.count) == 1

        let photo = responsePage.photos.first!
        expect(photo.id) == "28062536909"
        expect(photo.owner) == "142801205@N06"
        expect(photo.secret) == "dbd6a30d6c"
        expect(photo.server) == "4610"
        expect(photo.farm) == 5
        expect(photo.title) == "Machnower Schleuse"
        expect(photo.isPublic) == true
        expect(photo.isFriend) == false
        expect(photo.isFamily) == false
    }

    func testErrorJsonDecoder() {
        let photoResponse = try! JSONDecoder().decode(PhotoResponse.self, from: jsonError.data(using: .utf8)!)
        expect(photoResponse.status) == PhotoResponseStatus.failure
        expect(photoResponse.responsePage).to(beNil())
        expect(photoResponse.code).toNot(beNil())
        expect(photoResponse.message).toNot(beNil())
    }
}
