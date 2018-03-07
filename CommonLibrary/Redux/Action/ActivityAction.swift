//
//  ActivityAction.swift
//  Caminhante
//
//  Created by Luiz Rodrigo Martins Barbosa on 03.03.18.
//

import Foundation
import KleinKit

public enum ActivityAction: Action {
    case activityDidStart
    case activityDidPause
    case activityDidFinish
    case activityDidReset
    case healthTrackerDidWalkDistance(Measurement<UnitLength>)
    case healthTrackerDidBurnEnergy(Measurement<UnitEnergy>)
}
