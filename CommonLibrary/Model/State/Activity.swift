//
//  Activity.swift
//  Caminhante
//
//  Created by Luiz Rodrigo Martins Barbosa on 03.03.18.
//

import CoreLocation
import Foundation

public struct Activity {
    public var startDate: Date?
    public var endDate: Date?
    public var state: ActivityState
    public var locations: [CLLocation] = []
    public var snapshotPoints: [SnapshotPoint]
    public var totalEnergyBurned = Measurement(value: 0, unit: UnitEnergy.kilocalories)
    public var totalDistance = Measurement(value: 0, unit: UnitLength.meters)

    public init(state: ActivityState, snapshotPoints: [SnapshotPoint]) {
        self.state = state
        self.snapshotPoints = snapshotPoints
    }
}

extension Activity: Equatable {
    public static func == (lhs: Activity, rhs: Activity) -> Bool {
        return
            lhs.state == rhs.state &&
            lhs.snapshotPoints == rhs.snapshotPoints
    }
}
