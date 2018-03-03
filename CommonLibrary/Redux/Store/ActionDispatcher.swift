//
//  ActionDispatcher.swift
//  Caminhante
//
//  Created by Luiz Rodrigo Martins Barbosa on 03.03.18.
//

import Foundation
import KleinKit

public protocol ActionDispatcher {
    func dispatch(_ action: Action)
    func async<ActionRequestType: ActionRequest>(_ action: ActionRequestType)
}
