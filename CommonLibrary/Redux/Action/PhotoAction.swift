//
//  PhotoAction.swift
//  Caminhante
//
//  Created by Luiz Rodrigo Martins Barbosa on 04.03.18.
//

import CoreLocation
import KleinKit

public enum PhotoAction: Action {
    case gotPhotoInformation(Result<PhotoInformation>, at: CLLocation)
    case gotPhotoData(Result<Data>, photoId: String)
}
