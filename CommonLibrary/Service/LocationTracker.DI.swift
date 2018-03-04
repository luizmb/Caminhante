//
//  LocationTrackerDI.swift
//  Caminhante
//
//  Created by Luiz Rodrigo Martins Barbosa on 04.03.18.
//

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
