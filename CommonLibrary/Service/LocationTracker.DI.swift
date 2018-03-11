import Foundation
import KleinKit

extension InjectorProtocol {
    public var locationTracker: LocationTracker { return self.mapper.getSingleton()! }
}

public protocol HasLocationTracker { }
extension HasLocationTracker {
    public static var locationTracker: LocationTracker {
        return injector().locationTracker
    }

    public var locationTracker: LocationTracker {
        return injector().locationTracker
    }
}
