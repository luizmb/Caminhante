import Foundation
import HealthKit
import KleinKit

public class DefaultMapResolver {
    public static func mapServices() {
        guard let injector = (Injector.shared as? Injector) else { return }

        injector.mapper.mapSingleton(ActionDispatcher.self) { return Store.shared }
        injector.mapper.mapSingleton(PhotoAPI.self) { return FlickrAPI.shared }
        injector.mapper.mapSingleton(StateProvider.self) { Store.shared }
        injector.mapper.mapSingleton(LocationTracker.self) { CoreLocationTracker.shared }
        injector.mapper.mapSingleton(RemoteDevice.self) { WatchConnectivityControl.shared }
        injector.mapper.mapSingleton(HealthTracker.self) { HealthKitTracker.shared }
        injector.mapper.mapFactory(HealthStore.self) { { HKHealthStore() } }
        injector.mapper.mapFactory(Date.self) { { Date() } }
    }
}

extension DefaultMapResolver {
    public static func map() {
        mapServices()
    }
}
