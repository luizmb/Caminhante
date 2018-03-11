import Foundation

/// Response status: success or failure
public enum PhotoResponseStatus: String, Codable {
    case success = "ok"
    case failure = "fail"
}
