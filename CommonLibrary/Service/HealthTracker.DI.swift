//
//  HealthTracker.DI.swift
//  Caminhante
//
//  Created by Luiz Rodrigo Martins Barbosa on 04.03.18.
//

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
