//
//  PhotoResult.swift
//  CommonLibrary iOS
//
//  Created by Luiz Rodrigo Martins Barbosa on 02.03.18.
//

import Foundation

/// Photo successful response container
/// Contains the page fetched from Flickr
public struct PhotoResponsePage: Codable {

    /// Page index (1-based) retrieved from Flickr
    public let currentPage: Int

    /// Total of pages that can be retrieved with this filter
    public let pageCount: Int

    /// Photos per page
    public let pageSize: Int

    /// Total of photos that current filter could find
    public let filterCount: Int

    /// Photos retrieved for the current page
    public let photos: [PhotoInformation]
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
        self.photos = try container.decode([PhotoInformation].self, forKey: .photos)
    }
}
