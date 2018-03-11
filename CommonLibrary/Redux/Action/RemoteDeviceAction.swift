import Foundation
import KleinKit

public enum RemoteDeviceAction: Action {
    case activationComplete(success: Bool)
    case reachabilityChanged(isReachable: Bool)
}
