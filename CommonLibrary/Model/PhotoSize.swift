//
//  PhotoSize.swift
//  CommonLibrary iOS
//
//  Created by Luiz Rodrigo Martins Barbosa on 02.03.18.
//

import Foundation

public enum PhotoSize: String {
    case smallSquare = "s" // small square 75x75
    case largeSquare = "q" // large square 150x150
    case thumbnail = "t" // thumbnail, 100 on longest side
    case small240 = "m" // small, 240 on longest side
    case small320 = "n" // small, 320 on longest side
    case medium500 = "-" // medium, 500 on longest side
    case medium640 = "z" // medium 640, 640 on longest side
    case medium800 = "c" // medium 800, 800 on longest side†
    case large1024 = "b" // large, 1024 on longest side*
    case large1600 = "h" // large 1600, 1600 on longest side†
    case large2048 = "k" // large 2048, 2048 on longest side†
    case original = "o" // original image, either a jpg, gif or png, depending on source format
}
