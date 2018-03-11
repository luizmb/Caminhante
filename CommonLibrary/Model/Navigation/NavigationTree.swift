import Foundation

public enum NavigationTree: String {
    case activityControls = "ActivityControlsInterfaceController"
    case activityPhotoStream = "ActivitySnapshotsInterfaceController"

    public static func root() -> NavigationTree {
        return .activityControls
    }

    public var controller: String {
        return self.rawValue
    }
}

extension NavigationTree: Equatable { }
