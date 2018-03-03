//
//  NavigationRoute.swift
//  Caminhante
//
//  Created by Luiz Rodrigo Martins Barbosa on 03.03.18.
//

import Foundation

public struct NavigationRoute {
    public let origin: NavigationTree
    public let destination: NavigationTree
}

extension NavigationRoute: Equatable {
    public static func == (lhs: NavigationRoute, rhs: NavigationRoute) -> Bool {
        return lhs.origin == rhs.origin && lhs.destination == rhs.destination
    }
}
