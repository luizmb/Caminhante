//
//  File.swift
//  Caminhante
//
//  Created by Luiz Rodrigo Martins Barbosa on 03.03.18.
//

import Foundation

public enum NavigationTree {
    case activityControls
    case activitySnapshots

    public static func root() -> NavigationTree {
        return .activityControls
    }
}

extension NavigationTree: Equatable { }
