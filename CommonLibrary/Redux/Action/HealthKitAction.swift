//
//  HealthKitAction.swift
//  Caminhante
//
//  Created by Luiz Rodrigo Martins Barbosa on 04.03.18.
//

import KleinKit

public enum HealthKitAction: Action {
    case permissionChanged(newPermission: Permission)
}
