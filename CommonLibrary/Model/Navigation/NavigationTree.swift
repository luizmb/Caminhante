//
//  File.swift
//  Caminhante
//
//  Created by Luiz Rodrigo Martins Barbosa on 03.03.18.
//

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
