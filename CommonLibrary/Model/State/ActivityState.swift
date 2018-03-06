//
//  ActivityState.swift
//  Caminhante
//
//  Created by Luiz Rodrigo Martins Barbosa on 03.03.18.
//

import Foundation

public enum ActivityState: Int, Codable {
    public static let className = String(describing: ActivityState.self)

    case paused
    case inProgress
    case finished
}

extension ActivityState: Equatable {
}
