//
//  WorkoutTracker.DI.swift
//  Caminhante
//
//  Created by Luiz Rodrigo Martins Barbosa on 04.03.18.
//

import Foundation
import KleinKit

extension InjectorProtocol {
    public var workoutTracker: WorkoutTracker { return self.mapper.getSingleton()! }
}

public protocol HasWorkoutTracker { }
extension HasWorkoutTracker {
    public static var workoutTracker: WorkoutTracker {
        return injector().workoutTracker
    }

    public var workoutTracker: WorkoutTracker {
        return injector().workoutTracker
    }
}
