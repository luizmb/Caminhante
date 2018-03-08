//
//  WorkoutSessionState.swift
//  Caminhante
//
//  Created by Luiz Rodrigo Martins Barbosa on 08.03.18.
//

import Foundation
import HealthKit

struct WorkoutSessionState {
    var session: HKWorkoutSession
    var events = [HKWorkoutEvent]()
    var queries = [HKQuery]()
    let workoutRouteBuilder: HKWorkoutRouteBuilder

    init(session: HKWorkoutSession, store: HKHealthStore) {
        self.session = session
        self.workoutRouteBuilder = HKWorkoutRouteBuilder(healthStore: store, device: nil)
    }

    init?(store: HKHealthStore) {
        let config = HKWorkoutConfiguration()
        config.activityType = .walking
        config.locationType = .outdoor
        guard let session = try? HKWorkoutSession(configuration: config) else { return nil }
        self.session = session
        self.workoutRouteBuilder = HKWorkoutRouteBuilder(healthStore: store, device: nil)
    }
}
