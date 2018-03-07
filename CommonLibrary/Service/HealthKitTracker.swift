//
//  HealthKitTracker.swift
//  Caminhante
//
//  Created by Luiz Rodrigo Martins Barbosa on 04.03.18.
//

import CoreLocation
import Foundation
import KleinKit

public protocol HealthKitTracker {
    func requestAuthorization()
    func start()
    func pause()
    func resume()
    func stop()
    func reset()
    func save(from startDate: Date,
              to endDate: Date,
              distance: Measurement<UnitLength>,
              energy: Measurement<UnitEnergy>,
              locations: [CLLocation])
    func startAccumulatingData(from startDate: Date)
}
