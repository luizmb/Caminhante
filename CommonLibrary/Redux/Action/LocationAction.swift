//
//  LocationAction.swift
//  Caminhante
//
//  Created by Luiz Rodrigo Martins Barbosa on 04.03.18.
//

import KleinKit

public enum LocationAction: Action {
    case permissionChanged(newPermission: Permission)
    case receivedNewLocation(latitude: Double, longitude: Double)
}
