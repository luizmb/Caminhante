//
//  PhotoTests.swift
//  CommonLibraryTests
//
//  Created by Luiz Rodrigo Martins Barbosa on 02.03.18.
//

@testable import CommonLibrary
import Foundation
import Nimble
import XCTest

class PhotoTests: BaseTests {
    let photo = Photo(id: "1", owner: "my-owner", secret: "my-secret",
                      server: "my-server", farm: 9, title: "my-title",
                      isPublic: true, isFriend: false, isFamily: false)

    func testUrlForAllSizes() {
        let url = photo.url
        expect(url(.smallSquare).absoluteString) == "https://farm9.staticflickr.com/my-server/1_my-secret_s.jpg"
        expect(url(.largeSquare).absoluteString) == "https://farm9.staticflickr.com/my-server/1_my-secret_q.jpg"
        expect(url(.thumbnail).absoluteString) == "https://farm9.staticflickr.com/my-server/1_my-secret_t.jpg"
        expect(url(.small240).absoluteString) == "https://farm9.staticflickr.com/my-server/1_my-secret_m.jpg"
        expect(url(.small320).absoluteString) == "https://farm9.staticflickr.com/my-server/1_my-secret_n.jpg"
        expect(url(.medium500).absoluteString) == "https://farm9.staticflickr.com/my-server/1_my-secret_-.jpg"
        expect(url(.medium640).absoluteString) == "https://farm9.staticflickr.com/my-server/1_my-secret_z.jpg"
        expect(url(.medium800).absoluteString) == "https://farm9.staticflickr.com/my-server/1_my-secret_c.jpg"
        expect(url(.large1024).absoluteString) == "https://farm9.staticflickr.com/my-server/1_my-secret_b.jpg"
        expect(url(.large1600).absoluteString) == "https://farm9.staticflickr.com/my-server/1_my-secret_h.jpg"
        expect(url(.large2048).absoluteString) == "https://farm9.staticflickr.com/my-server/1_my-secret_k.jpg"
        expect(url(.original).absoluteString) == "https://farm9.staticflickr.com/my-server/1_my-secret_o.jpg"
    }

    func testUrlForiPhone() {
        let sut = photo
        expect(sut.iPhoneUrl.absoluteString) == "https://farm9.staticflickr.com/my-server/1_my-secret_c.jpg"
    }

    func testUrlForAppleWatch() {
        let sut = photo
        expect(sut.watchUrl.absoluteString) == "https://farm9.staticflickr.com/my-server/1_my-secret_n.jpg"
    }
}
