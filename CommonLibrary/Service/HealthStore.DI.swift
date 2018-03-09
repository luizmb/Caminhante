//
//  HealthStore.DI.swift
//  CommonLibrary iOS
//
//  Created by Luiz Rodrigo Martins Barbosa on 09.03.18.
//

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
