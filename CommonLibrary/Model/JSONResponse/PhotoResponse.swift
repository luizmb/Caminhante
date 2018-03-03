//
//  PhotoResult.swift
//  CommonLibrary iOS
//
//  Created by Luiz Rodrigo Martins Barbosa on 03.03.18.
//

import Foundation

/// Flickr response envelope
public struct PhotoResponse: Codable {

    /// Successful response container
    /// It's null when response has failed
    public let responsePage: PhotoResponsePage?

    /// Error code
    /// It's null when response has succeeded
    public let code: PhotoResponseErrorCode?

    /// Error message
    /// It's null when response has succeeded
    public let message: String?

    /// Response status
    public let status: PhotoResponseStatus
}

extension PhotoResponse {
    enum CodingKeys: String, CodingKey {
        case responsePage = "photos"
        case code = "code"
        case message = "message"
        case status = "stat"
    }
}
