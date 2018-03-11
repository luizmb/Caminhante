import Foundation
import KleinKit

public struct HealthKitReducer: Reducer {
    public func reduce(_ currentState: AppState, action: Action) -> AppState {
        guard let healthKitAction = action as? HealthKitAction else { return currentState }

        var stateCopy = currentState

        switch healthKitAction {
        case .permissionChanged(let newPermission):
            stateCopy.deviceState.healthPermission = newPermission
        }
        return stateCopy
    }
}
