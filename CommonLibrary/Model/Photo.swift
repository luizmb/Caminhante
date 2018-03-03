//
//  Photo.swift
//  CommonLibrary iOS
//
//  Created by Luiz Rodrigo Martins Barbosa on 02.03.18.
//

import Foundation

public struct Photo: Codable {
    public let id: String
    public let owner: String
    public let secret: String
    public let server: String
    public let farm: Int
    public let title: String
    public let isPublic: Bool
    public let isFriend: Bool
    public let isFamily: Bool

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

extension Photo {
    public func url(for size: PhotoSize) -> URL {
        return URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_\(size.rawValue).jpg")!
    }

    public var iPhoneUrl: URL {
        return url(for: .medium800)
    }

    public var watchUrl: URL {
        return url(for: .small320)
    }
}

extension Photo {
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
