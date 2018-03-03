//
//  AppState.swift
//  Caminhante
//
//  Created by Luiz Rodrigo Martins Barbosa on 03.03.18.
//

import Foundation

public struct AppState {
    public var currentActivity: Activity
    public var deviceState: DeviceState
}

extension AppState: Equatable {
    public static func == (lhs: AppState, rhs: AppState) -> Bool {
        return lhs.currentActivity == rhs.currentActivity
    }
}
