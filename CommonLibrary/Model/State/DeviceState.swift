//
//  DeviceState.swift
//  Caminhante
//
//  Created by Luiz Rodrigo Martins Barbosa on 03.03.18.
//

import Foundation

public struct DeviceState {
    public var isInBackground: Bool
    public var isActive: Bool
    public var hasLocationPermission: Bool
    public var hasHealthPermission: Bool

    public init(isInBackground: Bool, isActive: Bool, hasLocationPermission: Bool, hasHealthPermission: Bool) {
        self.isInBackground = isInBackground
        self.isActive = isActive
        self.hasLocationPermission = hasLocationPermission
        self.hasHealthPermission = hasHealthPermission
    }
}

extension DeviceState: Equatable {
    public static func == (lhs: DeviceState, rhs: DeviceState) -> Bool {
        return
            lhs.isInBackground == rhs.isInBackground &&
            lhs.isActive == rhs.isActive &&
            lhs.hasLocationPermission == rhs.hasLocationPermission &&
            lhs.hasHealthPermission == rhs.hasHealthPermission
    }
}
