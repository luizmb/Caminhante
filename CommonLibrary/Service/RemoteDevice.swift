//
//  RemoteDevice.swift
//  Caminhante
//
//  Created by Luiz Rodrigo Martins Barbosa on 06.03.18.
//

import Foundation
import KleinKit

public protocol RemoteDevice {
    func activateSession()
    func updateState<T: Codable>(type: String, data: T)
    func send<T: Codable>(type: String, data: T)
    func send<T: Codable>(type: String, data: T, completion: @escaping (Result<Void>) -> Void)
}
