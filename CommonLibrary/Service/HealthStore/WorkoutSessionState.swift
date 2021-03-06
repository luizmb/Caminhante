import Foundation
import HealthKit

struct WorkoutSessionState {
    var session: HKWorkoutSession
    var events = [HKWorkoutEvent]()
    var queries = [HKQuery]()
    let workoutRouteBuilder: HKWorkoutRouteBuilder

    init(session: HKWorkoutSession, healthStore: HealthStore) {
        self.session = session
        self.workoutRouteBuilder = HKWorkoutRouteBuilder(healthStore: healthStore as! HKHealthStore,
                                                         device: nil)
    }

    init?(healthStore: HealthStore) {
        let config = HKWorkoutConfiguration()
        config.activityType = .walking
        config.locationType = .outdoor
        guard let session = try? HKWorkoutSession(configuration: config) else { return nil }
        self.session = session
        self.workoutRouteBuilder = HKWorkoutRouteBuilder(healthStore: healthStore as! HKHealthStore,
                                                         device: nil)
    }
}
