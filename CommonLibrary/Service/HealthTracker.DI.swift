import Foundation
import KleinKit

extension InjectorProtocol {
    public var healthTracker: HealthTracker { return self.mapper.getSingleton()! }
}

public protocol HasHealthTracker { }
extension HasHealthTracker {
    public static var healthTracker: HealthTracker {
        return injector().healthTracker
    }

    public var healthTracker: HealthTracker {
        return injector().healthTracker
    }
}
