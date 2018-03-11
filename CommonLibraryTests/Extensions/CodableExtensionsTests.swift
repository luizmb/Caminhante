@testable import CommonLibrary
import Foundation
import Nimble
import XCTest

class CodableExtensionsTests: BaseTests {

    struct BoolOrInt: Codable {
        let bool: Bool

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.bool = try container.decodeBoolOrInt(forKey: .bool)
        }
    }

    struct IntOrString: Codable {
        let int: Int

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.int = try container.decodeIntOrString(forKey: .int)
        }
    }

    func testDecodeBoolOrIntFromZero() {
        let jsonBytes = "{ \"bool\": 0 }".data(using: .utf8)!
        let decoded = try! JSONDecoder().decode(BoolOrInt.self, from: jsonBytes)
        expect(decoded.bool) == false
    }

    func testDecodeBoolOrIntFromOne() {
        let jsonBytes = "{ \"bool\": 1 }".data(using: .utf8)!
        let decoded = try! JSONDecoder().decode(BoolOrInt.self, from: jsonBytes)
        expect(decoded.bool) == true
    }

    func testDecodeBoolOrIntFromTwo() {
        let jsonBytes = "{ \"bool\": 2 }".data(using: .utf8)!
        expect {
            _ = try JSONDecoder().decode(BoolOrInt.self, from: jsonBytes)
        }.to(throwError())
    }

    func testDecodeBoolOrIntFromFalse() {
        let jsonBytes = "{ \"bool\": false }".data(using: .utf8)!
        let decoded = try! JSONDecoder().decode(BoolOrInt.self, from: jsonBytes)
        expect(decoded.bool) == false
    }

    func testDecodeBoolOrIntFromTrue() {
        let jsonBytes = "{ \"bool\": true }".data(using: .utf8)!
        let decoded = try! JSONDecoder().decode(BoolOrInt.self, from: jsonBytes)
        expect(decoded.bool) == true
    }

    func testDecodeIntOrStringFromInt() {
        let jsonBytes = "{ \"int\": 42 }".data(using: .utf8)!
        let decoded = try! JSONDecoder().decode(IntOrString.self, from: jsonBytes)
        expect(decoded.int) == 42
    }

    func testDecodeIntOrStringFromString() {
        let jsonBytes = "{ \"int\": \"42\" }".data(using: .utf8)!
        let decoded = try! JSONDecoder().decode(IntOrString.self, from: jsonBytes)
        expect(decoded.int) == 42
    }

    func testDecodeIntOrStringFromInvalidString() {
        let jsonBytes = "{ \"int\": \"oh no!!\" }".data(using: .utf8)!
        expect {
            _ = try JSONDecoder().decode(IntOrString.self, from: jsonBytes)
        }.to(throwError())
    }
}
