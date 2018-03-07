//
//  LocationAction.swift
//  Caminhante
//
//  Created by Luiz Rodrigo Martins Barbosa on 04.03.18.
//

import CoreLocation
import KleinKit

public enum LocationAction: Action {
    case permissionChanged(newPermission: Permission)
    case receivedNewLocations([CLLocation])
    case receivedNewSignificantLocation(CLLocation, id: UUID, photoTask: CancelableTask)
}
