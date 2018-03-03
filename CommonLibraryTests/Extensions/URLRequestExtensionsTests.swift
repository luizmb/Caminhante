//
//  URLRequestExtensionsTests.swift
//  CommonLibraryTests
//
//  Created by Luiz Rodrigo Martins Barbosa on 03.03.18.
//

@testable import CommonLibrary
import Foundation
import KleinKit
import Nimble
import XCTest

class URLRequestExtensionsTests: BaseTests {
    func testURLRequest() {
        let sut1 = URLRequest.createRequest(url: "http://www.foo.com/resource/test.json", httpMethod: "GET")
        expect(sut1.url?.absoluteString) == "http://www.foo.com/resource/test.json"
        expect(sut1.httpMethod) == "GET"

        let sut2 = URLRequest.createRequest(url: "http://www.foo.com/resource/test2.json",
                                            httpMethod: "POST",
                                            urlParams: ["a": "a1", "b": "b1"])
        expect(["http://www.foo.com/resource/test2.json?a=a1&b=b1",
                "http://www.foo.com/resource/test2.json?b=b1&a=a1"]).to(contain(sut2.url!.absoluteString))
        expect(sut2.httpMethod) == "POST"
    }

    func testURLAppendFirstParameter() {
        let originalRequest = URLRequest(url: URL(string: "https://google.com.br/")!)
        let requestWithNewParameter = originalRequest.appendingParameter(key: "keyParam", value: "valueParam")
        let sut = requestWithNewParameter.url?.absoluteString
        expect(sut) == "https://google.com.br/?keyParam=valueParam"
    }

    func testURLAppendSecondParameter() {
        let originalRequest = URLRequest(url: URL(string: "https://google.com.br/?first=firstValue")!)
        let requestWithNewParameter = originalRequest.appendingParameter(key: "keyParam", value: "valueParam")
        let sut = requestWithNewParameter.url?.absoluteString
        expect(sut) == "https://google.com.br/?first=firstValue&keyParam=valueParam"
    }
}
