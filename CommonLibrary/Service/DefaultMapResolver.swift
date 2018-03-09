//
//  DefaultMapper.swift
//  Caminhante watchOS Extension
//
//  Created by Luiz Rodrigo Martins Barbosa on 03.03.18.
//

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
    }
}

extension DefaultMapResolver {
    public static func map() {
        mapServices()
    }
}
