//
//  HealthKitTracker.swift
//  Caminhante
//
//  Created by Luiz Rodrigo Martins Barbosa on 04.03.18.
//

import Foundation
import KleinKit

public protocol HealthKitTracker {
    func requestAuthorization()
    func start()
    func stop()
}
