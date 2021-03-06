import Foundation

public struct AppState {
    public var currentActivity: Activity?
    public var deviceState: DeviceState
    public let significantDistance = Measurement(value: 100, unit: UnitLength.meters)

    public init() {
        currentActivity = nil
        deviceState = DeviceState(isInBackground: false, isActive: true, locationPermission: .pending, healthPermission: .pending)
    }

    public init(currentActivity: Activity?, deviceState: DeviceState) {
        self.currentActivity = currentActivity
        self.deviceState = deviceState
    }
}

extension AppState: Equatable {
    public static func == (lhs: AppState, rhs: AppState) -> Bool {
        return
            lhs.currentActivity == rhs.currentActivity &&
            lhs.deviceState == rhs.deviceState &&
            lhs.significantDistance == rhs.significantDistance
    }
}
