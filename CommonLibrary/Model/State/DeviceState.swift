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

public enum DeviceType {
    case appleWatch
    case iPhone
}

public struct DeviceState {
    public var isInBackground: Bool
    public var isActive: Bool
    public var locationPermission: Permission
    public var healthPermission: Permission
    public var counterPartConnection: Bool
    public var counterPartReachable: Bool
    public var deviceType: DeviceType = .iPhone

    public var navigation = NavigationTree.root()
    #if os(iOS)
    public weak var application: UIApplication?
    #endif

    public init(isInBackground: Bool, isActive: Bool, locationPermission: Permission, healthPermission: Permission) {
        self.isInBackground = isInBackground
        self.isActive = isActive
        self.locationPermission = locationPermission
        self.healthPermission = healthPermission
        self.counterPartConnection = false
        self.counterPartReachable = false
        #if os(watchOS)
        self.deviceType = .appleWatch
        #endif
    }
}

extension DeviceState: Equatable {
    public static func == (lhs: DeviceState, rhs: DeviceState) -> Bool {
        return
            lhs.isInBackground == rhs.isInBackground &&
            lhs.isActive == rhs.isActive &&
            lhs.locationPermission == rhs.locationPermission &&
            lhs.healthPermission == rhs.healthPermission &&
            lhs.navigation == rhs.navigation &&
            lhs.counterPartConnection == rhs.counterPartConnection &&
            lhs.counterPartReachable == rhs.counterPartReachable
    }
}
