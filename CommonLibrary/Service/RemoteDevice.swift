import Foundation
import KleinKit

public protocol RemoteDevice {
    func activateSession()
    func updateState<T: Codable>(type: String, data: T)
    func send<T: Codable>(type: String, data: T)
    func send<T: Codable>(type: String, data: T, completion: @escaping (Result<Void>) -> Void)
}
