//
//  PhotoSize.swift
//  CommonLibrary iOS
//
//  Created by Luiz Rodrigo Martins Barbosa on 02.03.18.
//

import Foundation

/// Possible Flickr photo sizes
public enum PhotoSize: String {
    /// PhotoSize: small square 75x75
    case smallSquare = "s"

    /// PhotoSize: large square 150x150
    case largeSquare = "q"

    /// PhotoSize: thumbnail, 100 on longest side
    case thumbnail = "t"

    /// PhotoSize: small, 240 on longest side
    case small240 = "m"

    /// PhotoSize: small, 320 on longest side
    case small320 = "n"

    /// PhotoSize: medium, 500 on longest side
    case medium500 = "-"

    /// PhotoSize: medium 640, 640 on longest side
    case medium640 = "z"

    /// PhotoSize: medium 800, 800 on longest side†
    case medium800 = "c"

    /// PhotoSize: large, 1024 on longest side*
    case large1024 = "b"

    /// PhotoSize: large 1600, 1600 on longest side†
    case large1600 = "h"

    /// PhotoSize: large 2048, 2048 on longest side†
    case large2048 = "k"

    /// PhotoSize: original image, either a jpg, gif or png, depending on source format
    case original = "o"
}
