//
//  Permission.swift
//  Caminhante
//
//  Created by Luiz Rodrigo Martins Barbosa on 04.03.18.
//

import Foundation

public enum Permission: Equatable {
    case authorized
    case denied
    case pending
}

extension Permission {
    public var englishDescription: String {
        switch self {
        case .authorized: return "Authorized"
        case .denied: return "Denied"
        case .pending: return "Pending"
        }
    }

    public var localizableString: String {
        switch self {
        case .authorized: return "PERMISSION_Authorized"
        case .denied: return "PERMISSION_Denied"
        case .pending: return "PERMISSION_Pending"
        }
    }
}
