//
//  PhotoResult.swift
//  CommonLibrary iOS
//
//  Created by Luiz Rodrigo Martins Barbosa on 03.03.18.
//

import Foundation

public struct PhotoResponse: Codable {
    public let responsePage: PhotoResponsePage
    public let status: String
}

extension PhotoResponse {
    enum CodingKeys: String, CodingKey {
        case responsePage = "photos"
        case status = "stat"
    }
}
