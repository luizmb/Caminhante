//
//  PhotoResult.swift
//  CommonLibrary iOS
//
//  Created by Luiz Rodrigo Martins Barbosa on 03.03.18.
//

import Foundation

public struct PhotoResult: Codable {
    public let photosPage: PhotoPageResult
    public let status: String
}

extension PhotoResult {
    enum CodingKeys: String, CodingKey {
        case photosPage = "photos"
        case status = "stat"
    }
}
