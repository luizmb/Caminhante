import Foundation
import KleinKit

public struct RemoteDeviceReducer: Reducer {
    public func reduce(_ currentState: AppState, action: Action) -> AppState {
        guard let remoteDeviceAction = action as? RemoteDeviceAction else { return currentState }

        var stateCopy = currentState

        switch remoteDeviceAction {
        case .activationComplete(let success):
            stateCopy.deviceState.counterPartConnection = success
        case .reachabilityChanged(let isReachable):
            stateCopy.deviceState.counterPartReachable = isReachable
        }

        return stateCopy
    }
}
