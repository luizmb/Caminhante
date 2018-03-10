//
//  Today.DI.swift
//  Caminhante
//
//  Created by Luiz Rodrigo Martins Barbosa on 10.03.18.
//

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
