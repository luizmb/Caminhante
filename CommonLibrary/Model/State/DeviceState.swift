//
//  DeviceState.swift
//  Caminhante
//
//  Created by Luiz Rodrigo Martins Barbosa on 03.03.18.
//

import Foundation
#if os(iOS)
import UIKit
#endif

public struct DeviceState {
    public var isInBackground: Bool
    public var isActive: Bool
    public var locationPermission: Permission
    public var healthPermission: Permission

    public var navigation = NavigationTree.root()
    #if os(iOS)
    public weak var application: UIApplication?
    #endif

    public init(isInBackground: Bool, isActive: Bool, locationPermission: Permission, healthPermission: Permission) {
        self.isInBackground = isInBackground
        self.isActive = isActive
        self.locationPermission = locationPermission
        self.healthPermission = healthPermission
    }
}

extension DeviceState: Equatable {
    public static func == (lhs: DeviceState, rhs: DeviceState) -> Bool {
        return
            lhs.isInBackground == rhs.isInBackground &&
            lhs.isActive == rhs.isActive &&
            lhs.locationPermission == rhs.locationPermission &&
            lhs.healthPermission == rhs.healthPermission &&
            lhs.navigation == rhs.navigation
    }
}
