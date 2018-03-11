import CommonLibrary
import CoreLocation
import HealthKit
import KleinKit
import WatchKit

enum BootstrapActionRequest: ActionRequest {
    case boot

    func execute(getState: @escaping () -> AppState,
                 dispatch: @escaping DispatchFunction,
                 dispatchAsync: @escaping (AnyActionAsync<AppState>) -> Void) {
        switch self {
        case .boot:
            WKInterfaceController.reloadRootPageControllers(withNames: [NavigationTree.activityControls.controller,
                                                                        NavigationTree.activityPhotoStream.controller],
                                                            contexts: nil,
                                                            orientation: WKPageOrientation.horizontal,
                                                            pageIndex: 0)

            dispatch(RouterAction.didStart)

            locationTracker.requestAuthorization()
            healthTracker.requestAuthorization()
            remoteDevice.activateSession()
        }
    }
}

extension BootstrapActionRequest: HasLocationTracker { }
extension BootstrapActionRequest: HasHealthTracker { }
extension BootstrapActionRequest: HasRemoteDevice { }
