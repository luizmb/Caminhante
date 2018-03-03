//
//  PhotoDecodableTests.swift
//  CommonLibraryTests
//
//  Created by Luiz Rodrigo Martins Barbosa on 03.03.18.
//

import Foundation

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

    func testJsonDecoder() {
        let photoResponse = try! JSONDecoder().decode(PhotoResponse.self, from: json.data(using: .utf8)!)
        expect(photoResponse.status) == "ok"
        expect(photoResponse.responsePage.currentPage) == 1
        expect(photoResponse.responsePage.pageCount) == 540
        expect(photoResponse.responsePage.pageSize) == 1
        expect(photoResponse.responsePage.filterCount) == 540
        expect(photoResponse.responsePage.photos.count) == 1

        let photo = photoResponse.responsePage.photos.first!
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
}
