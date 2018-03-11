import Foundation
import HealthKit

extension HKQuantityType {
    public static func distanceWalkingRunning() -> HKQuantityType {
        return HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!
    }

    public static func distanceCycling() -> HKQuantityType {
        return HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceCycling)!
    }

    public static func activeEnergyBurned() -> HKQuantityType {
        return HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!
    }

    public static func heartRate() -> HKQuantityType {
        return HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
    }
}
