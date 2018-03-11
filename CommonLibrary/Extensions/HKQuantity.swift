import Foundation
import HealthKit

extension Measurement where UnitType == UnitEnergy {
    public func toQuantity() -> HKQuantity {
        let value = self.converted(to: .kilocalories).value
        return HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: value)
    }
}

extension Measurement where UnitType == UnitLength {
    public func toQuantity() -> HKQuantity {
        let value = self.converted(to: .meters).value
        return HKQuantity(unit: HKUnit.meter(), doubleValue: value)
    }
}
