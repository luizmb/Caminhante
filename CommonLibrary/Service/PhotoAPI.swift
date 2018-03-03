//
//  PhotoAPI.swift
//  Caminhante
//
//  Created by Luiz Rodrigo Martins Barbosa on 03.03.18.
//

import Foundation
import KleinKit

public protocol PhotoAPI {
    func request(_ endpoint: PhotoServiceEndpoint,
                 completion: @escaping (Result<Data>) -> Void) -> CancelableTask
}
