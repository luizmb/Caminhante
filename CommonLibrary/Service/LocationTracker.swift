//
//  LocationTracker.swift
//  Caminhante
//
//  Created by Luiz Rodrigo Martins Barbosa on 04.03.18.
//

import Foundation
import KleinKit

public protocol LocationTracker {
    func requestAuthorization()
    var isAllowed: Bool { get }
    func start()
    func stop()
}
