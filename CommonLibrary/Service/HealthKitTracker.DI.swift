//
//  HealthKitTracker.DI.swift
//  Caminhante
//
//  Created by Luiz Rodrigo Martins Barbosa on 04.03.18.
//

import Foundation
import KleinKit

extension InjectorProtocol {
    public var healthKitTracker: HealthKitTracker { return self.mapper.getSingleton()! }
}

public protocol HasHealthKitTracker { }
extension HasHealthKitTracker {
    public static var healthKitTracker: HealthKitTracker {
        return injector().healthKitTracker
    }

    public var healthKitTracker: HealthKitTracker {
        return injector().healthKitTracker
    }
}
