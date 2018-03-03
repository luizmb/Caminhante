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
        let photoResult = try! JSONDecoder().decode(PhotoResult.self, from: json.data(using: .utf8)!)
        expect(photoResult.status) == "ok"
        expect(photoResult.photosPage.currentPage) == 1
        expect(photoResult.photosPage.pageCount) == 540
        expect(photoResult.photosPage.pageSize) == 1
        expect(photoResult.photosPage.filterCount) == 540
        expect(photoResult.photosPage.photos.count) == 1

        let photo = photoResult.photosPage.photos.first!
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
