import Foundation
import KleinKit

extension InjectorProtocol {
    public var todayFactory: () -> Date { return self.mapper.getFactory()! }
}

public protocol HasToday {
}

extension HasToday {
    public var now: () -> Date {
        return injector().todayFactory
    }
}
