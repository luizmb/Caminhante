//
//  IntegrationFlickrTests.swift
//  CommonLibraryTests
//
//  Created by Luiz Rodrigo Martins Barbosa on 03.03.18.
//

@testable import CommonLibrary
import CoreLocation
import Foundation
import KleinKit
import Nimble
import XCTest

class IntegrationFlickrTests: BaseTests {
    func testPublicPhotosNearbyValidResponse() {
        let client = FlickrAPI(session: URLSession.shared)
        let apple = CLLocationCoordinate2D(latitude: 37.332_624_1,
                                           longitude: -122.030_862_1)

        waitUntil { done in
            client.request(.publicPhotosNearby(location: apple, page: 1, pageSize: 1)) { httpResult in
                switch httpResult {
                case .success(let data):
                    expect(data.count) > 10
                    done()
                case .failure(let error):
                    fail("Unexpected error: \(error)")
                }
            }
        }
    }

    func testPublicPhotosNearbySuccessfulIntegrationTest() {
        let client = FlickrAPI(session: URLSession.shared)
        let apple = CLLocationCoordinate2D(latitude: 37.332_624_1,
                                           longitude: -122.030_862_1)

        waitUntil { done in
            client.request(.publicPhotosNearby(location: apple, page: 1, pageSize: 1)) { httpResult in
                let jsonResult: Result<PhotoResponse> = httpResult.flatMap(JsonParser.decode)
                switch jsonResult {
                case .success(let photoResponse):
                    expect(photoResponse.status) == PhotoResponseStatus.success
                    expect(photoResponse.responsePage?.photos.count) == 1
                    done()
                case .failure(let error):
                    fail("Unexpected error: \(error)")
                }
            }
        }
    }

    func testPublicPhotosNearbyWrongParameterIntegrationTest() {
        let client = FlickrAPI(session: URLSession.shared)
        let apple = CLLocationCoordinate2D(latitude: 337.332_624_1,
                                           longitude: -122.030_862_1)

        waitUntil { done in
            client.request(.publicPhotosNearby(location: apple, page: 1, pageSize: 1)) { httpResult in
                let jsonResult: Result<PhotoResponse> = httpResult.flatMap(JsonParser.decode)
                switch jsonResult {
                case .success(let photoResponse):
                    expect(photoResponse.status) == PhotoResponseStatus.failure
                    expect(photoResponse.code) == PhotoResponseErrorCode.unknown
                    done()
                case .failure(let error):
                    fail("Unexpected error: \(error)")
                }
            }
        }
    }
}
