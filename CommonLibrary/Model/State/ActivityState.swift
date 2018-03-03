//
//  WorkoutState.swift
//  Caminhante
//
//  Created by Luiz Rodrigo Martins Barbosa on 03.03.18.
//

import Foundation

public enum ActivityState {
    case paused
    case inProgress
    case finished
}

extension ActivityState: Equatable {
}
