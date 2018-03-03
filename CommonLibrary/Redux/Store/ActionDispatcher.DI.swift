//
//  ActionDispatcher.DI.swift
//  Caminhante
//
//  Created by Luiz Rodrigo Martins Barbosa on 03.03.18.
//

import Foundation
import KleinKit

extension InjectorProtocol {
    public var actionDispatcher: ActionDispatcher { return self.mapper.getSingleton()! }
}

public protocol HasActionDispatcher { }
extension HasActionDispatcher {
    public static var actionDispatcher: ActionDispatcher {
        return injector().actionDispatcher
    }

    public var actionDispatcher: ActionDispatcher {
        return injector().actionDispatcher
    }
}
