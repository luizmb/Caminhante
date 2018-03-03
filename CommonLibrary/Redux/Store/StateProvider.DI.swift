//
//  StateProvider.DI.swift
//  Caminhante
//
//  Created by Luiz Rodrigo Martins Barbosa on 03.03.18.
//

import Foundation
import KleinKit

extension InjectorProtocol {
    public var stateProvider: StateProvider { return self.mapper.getSingleton()! }
}

public protocol HasStateProvider { }
extension HasStateProvider {
    public static var stateProvider: StateProvider {
        return injector().stateProvider
    }

    public var stateProvider: StateProvider {
        return injector().stateProvider
    }
}
