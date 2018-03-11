import Foundation
import KleinKit

public protocol LocationTracker {
    func requestAuthorization()
    var isAllowed: Bool { get }
    func start()
    func stop()
}
