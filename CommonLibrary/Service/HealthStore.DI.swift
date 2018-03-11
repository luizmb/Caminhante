import Foundation
import KleinKit

extension InjectorProtocol {
    public var healthStoreFactory: () -> HealthStore { return self.mapper.getFactory()! }
}

public protocol HasHealthStore {
    var healthStore: HealthStore { get }
}

extension HasHealthStore {
    public var healthStoreFactory: () -> HealthStore {
        return injector().healthStoreFactory
    }
}
