//
//  PhotoResponseStatus.swift
//  CommonLibraryTests
//
//  Created by Luiz Rodrigo Martins Barbosa on 03.03.18.
//

import Foundation

/// Response status: success or failure
public enum PhotoResponseStatus: String, Codable {
    case success = "ok"
    case failure = "fail"
}
