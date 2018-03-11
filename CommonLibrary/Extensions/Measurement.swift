import Foundation

extension Measurement {
    fileprivate func string(digits: Int) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.maximumFractionDigits = digits

        return formatter.string(from: NSNumber(value: value)).map {
            "\($0) \(unit.symbol)"
        } ?? "0 \(unit.symbol)"
    }
}

extension Measurement where UnitType == UnitLength {
    public func format(digits: Int = 1) -> String {
        let m = converted(to: .meters)
        return m.value < 1_000
            ? m.string(digits: digits)
            : converted(to: .kilometers).string(digits: digits)
    }
}

extension Measurement where UnitType == UnitEnergy {
    public func format(digits: Int = 1) -> String {
        let cal = converted(to: .calories)
        return cal.value < 1_000
            ? cal.string(digits: digits)
            : converted(to: .kilocalories).string(digits: digits)
    }
}
