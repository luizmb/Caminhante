//
//  ActivityAction.swift
//  Caminhante
//
//  Created by Luiz Rodrigo Martins Barbosa on 03.03.18.
//

import KleinKit

public enum ActivityAction: Action {
    case activityDidStart
    case activityDidPause
    case activityDidFinish
    case activityDidReset
}
