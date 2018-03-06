//
//  RemoteDeviceAction.swift
//  Caminhante
//
//  Created by Luiz Rodrigo Martins Barbosa on 06.03.18.
//

import Foundation
import KleinKit

public enum RemoteDeviceAction: Action {
    case activationComplete(success: Bool)
    case reachabilityChanged(isReachable: Bool)
}
