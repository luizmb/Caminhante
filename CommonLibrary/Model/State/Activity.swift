//
//  Workout.swift
//  Caminhante
//
//  Created by Luiz Rodrigo Martins Barbosa on 03.03.18.
//

import Foundation

public struct Activity {
    public var state: ActivityState
    public var snapshotPoints: [SnapshotPoint]

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
