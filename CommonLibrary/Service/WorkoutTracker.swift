//
//  WorkoutTracker.swift
//  Caminhante
//
//  Created by Luiz Rodrigo Martins Barbosa on 04.03.18.
//

import Foundation
import KleinKit

public protocol WorkoutTracker {
    func requestAuthorization()
    func start()
    func stop()
}
