import CommonLibrary
import CoreLocation
import HealthKit
import KleinKit
import UIKit

enum BootstrapActionRequest: ActionRequest {
    case boot(UIApplication)

    func execute(getState: @escaping () -> AppState,
                 dispatch: @escaping DispatchFunction,
                 dispatchAsync: @escaping (AnyActionAsync<AppState>) -> Void) {
        switch self {
        case .boot(let application):
            dispatch(RouterAction.didStart(application))

            locationTracker.requestAuthorization()
            healthTracker.requestAuthorization()
            remoteDevice.activateSession()
        }
    }
}

extension BootstrapActionRequest: HasLocationTracker { }
extension BootstrapActionRequest: HasHealthTracker { }
extension BootstrapActionRequest: HasRemoteDevice { }
