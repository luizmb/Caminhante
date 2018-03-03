//
//  ActionRequest.swift
//  Caminhante
//
//  Created by Luiz Rodrigo Martins Barbosa on 03.03.18.
//

import Foundation
import KleinKit

public protocol ActionRequest: ActionAsync where StateType == AppState {
}
