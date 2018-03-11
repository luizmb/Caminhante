#if os(iOS)
import UIKit
#endif
import KleinKit

public enum RouterAction: Action {
    #if os(iOS)
    case didStart(UIApplication)
    #else
    case didStart
    #endif
    case didNavigate(NavigationTree)
}
