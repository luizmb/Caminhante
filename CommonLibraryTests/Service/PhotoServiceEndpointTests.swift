@testable import CommonLibrary
import CoreLocation
import Foundation
import KleinKit
import Nimble
import XCTest

class PhotoServiceEndpointTests: BaseTests {
    func testURLEndpoint_URLRequestFactory() {
        let location = CLLocationCoordinate2D(latitude: 43.2, longitude: 21.9)
        let publicPhotoNearby = PhotoServiceEndpoint.publicPhotosNearby(location: location,
                                                                        page: 1,
                                                                        pageSize: 10)
        let sut = publicPhotoNearby.urlRequest(with: "https://test.co/api")
        expect(sut.httpMethod) == "GET"
        expect(sut.url?.absoluteString) ==
            "https://test.co/api" +
            "?nojsoncallback=1" +
            "&page=1" +
            "&method=flickr.photos.search" +
            "&format=json" +
            "&lon=21.9" +
            "&radius=1" +
            "&lat=43.2" +
            "&safe_search=2" +
            "&per_page=10" +
            "&radius_units=km"
    }

    class SomethingWithPhotoAPI: HasPhotoAPI {
    }

    func testPhotoAPIInjector() {
        let injector = Injector.shared as! Injector
        injector.mapper.mapSingleton(PhotoAPI.self) { FlickrAPI.shared }

        let somethingWithPhotoAPI = SomethingWithPhotoAPI()
        expect(somethingWithPhotoAPI.photoAPI).to(beAnInstanceOf(FlickrAPI.self))

        let injectedPhotoAPI = somethingWithPhotoAPI.photoAPI as! FlickrAPI
        let singletonPhotoAPI = FlickrAPI.shared as! FlickrAPI
        expect(injectedPhotoAPI === singletonPhotoAPI).to(beTrue())
    }

    func testPhotoAPIStaticInjector() {
        let injector = Injector.shared as! Injector
        injector.mapper.mapSingleton(PhotoAPI.self) { FlickrAPI.shared }

        expect(SomethingWithPhotoAPI.photoAPI).to(beAnInstanceOf(FlickrAPI.self))

        let injectedPhotoAPI = SomethingWithPhotoAPI.photoAPI as! FlickrAPI
        let singletonPhotoAPI = FlickrAPI.shared as! FlickrAPI
        expect(injectedPhotoAPI === singletonPhotoAPI).to(beTrue())
    }
}
