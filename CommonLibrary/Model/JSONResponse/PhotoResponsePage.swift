//
//  PhotoResult.swift
//  CommonLibrary iOS
//
//  Created by Luiz Rodrigo Martins Barbosa on 02.03.18.
//

import Foundation

public struct PhotoResponsePage: Codable {
    public let currentPage: Int
    public let pageCount: Int
    public let pageSize: Int
    public let filterCount: Int
    public let photos: [Photo]
}

extension PhotoResponsePage {
    enum CodingKeys: String, CodingKey {
        case currentPage = "page"
        case pageCount = "pages"
        case pageSize = "perpage"
        case filterCount = "total"
        case photos = "photo"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.currentPage = try container.decodeIntOrString(forKey: .currentPage)
        self.pageCount = try container.decodeIntOrString(forKey: .pageCount)
        self.pageSize = try container.decodeIntOrString(forKey: .pageSize)
        self.filterCount = try container.decodeIntOrString(forKey: .filterCount)
        self.photos = try container.decode([Photo].self, forKey: .photos)
    }
}
