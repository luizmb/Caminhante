//
//  PhotoServiceEndpoint.swift
//  CommonLibraryTests
//
//  Created by Luiz Rodrigo Martins Barbosa on 03.03.18.
//

import CoreLocation
import Foundation

public enum PhotoServiceEndpoint {
    case publicPhotosNearby(location: CLLocationCoordinate2D, page: Int, pageSize: Int)
}
