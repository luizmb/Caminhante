//
//  Photo.swift
//  CommonLibrary iOS
//
//  Created by Luiz Rodrigo Martins Barbosa on 02.03.18.
//

import Foundation
import KleinKit

/// Information about Flickr Photo
public struct PhotoInformation: Codable {

    /// Photo ID on Flickr
    public let id: String

    /// Owner ID on Flickr
    public let owner: String

    /// Photo verification hash
    public let secret: String

    /// Server where photo is stored
    public let server: String

    /// Farm ID for the server where photo is stored
    public let farm: Int

    /// Photo title
    public let title: String

    /// Public can be shown without authentication
    public let isPublic: Bool

    /// Photo owner is friend of authenticated user
    public let isFriend: Bool

    /// Photo owner is within the same family as authenticated user
    public let isFamily: Bool

    /// Image or network task to download it
    public var image: SyncableResult<Data> = .neverLoaded

    /// Default initializer with all properties
    ///
    /// - Parameters:
    ///   - id: Photo ID on Flickr
    ///   - owner: Owner ID on Flickr
    ///   - secret: Photo verification hash
    ///   - server: Server where photo is stored
    ///   - farm: Farm ID for the server where photo is stored
    ///   - title: Photo title
    ///   - isPublic: Public can be shown without authentication
    ///   - isFriend: Photo owner is friend of authenticated user
    ///   - isFamily: Photo owner is within the same family as authenticated user
    public init(id: String, owner: String, secret: String,
                server: String, farm: Int, title: String,
                isPublic: Bool, isFriend: Bool, isFamily: Bool) {
        self.id = id
        self.owner = owner
        self.secret = secret
        self.server = server
        self.farm = farm
        self.title = title
        self.isPublic = isPublic
        self.isFriend = isFriend
        self.isFamily = isFamily
    }
}

extension PhotoInformation {

    /// Get the Flickr URL for this photo, given a size
    ///
    /// - Parameter size: Photo size
    /// - Returns: Photo Flickr URL for the given size
    public func url(for size: PhotoSize) -> URL {
        return URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_\(size.rawValue).jpg")!
    }

    /// Get the Flickr URL for this photo, optimized for iPhone screen
    public var iPhoneUrl: URL {
        return url(for: .medium800)
    }

    /// Get the Flickr URL for this photo, optimized for Apple Watch screen
    public var watchUrl: URL {
        return url(for: .small320)
    }
}

extension PhotoInformation {
    enum CodingKeys: String, CodingKey {
        case id, owner, secret, server, farm, title
        case isPublic = "ispublic"
        case isFriend = "isfriend"
        case isFamily = "isfamily"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.owner = try container.decode(String.self, forKey: .owner)
        self.secret = try container.decode(String.self, forKey: .secret)
        self.server = try container.decode(String.self, forKey: .server)
        self.farm = try container.decodeIntOrString(forKey: .farm)
        self.title = try container.decode(String.self, forKey: .title)
        self.isPublic = try container.decodeBoolOrInt(forKey: .isPublic)
        self.isFriend = try container.decodeBoolOrInt(forKey: .isFriend)
        self.isFamily = try container.decodeBoolOrInt(forKey: .isFamily)
    }
}

extension PhotoInformation: Equatable {
    public static func == (lhs: PhotoInformation, rhs: PhotoInformation) -> Bool {
        return
            lhs.id == rhs.id &&
            lhs.owner == rhs.owner &&
            lhs.secret == rhs.secret &&
            lhs.server == rhs.server &&
            lhs.farm == rhs.farm &&
            lhs.title == rhs.title &&
            lhs.isPublic == rhs.isPublic &&
            lhs.isFriend == rhs.isFriend &&
            lhs.isFamily == rhs.isFamily
    }
}
