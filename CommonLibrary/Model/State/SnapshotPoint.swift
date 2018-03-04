//
//  SnapshotPoint.swift
//  Caminhante
//
//  Created by Luiz Rodrigo Martins Barbosa on 03.03.18.
//

import CoreLocation
import Foundation
import KleinKit

public struct SnapshotPoint {
    public var identifier: UUID
    public var location: CLLocation
    public var photo: SyncableResult<PhotoInformation>
    public var time: Date

    public init(identifier: UUID = UUID(), location: CLLocation, photo: SyncableResult<PhotoInformation>, time: Date) {
        self.identifier = identifier
        self.location = location
        self.photo = photo
        self.time = time
    }
}

extension SnapshotPoint: Equatable {
    public static func == (lhs: SnapshotPoint, rhs: SnapshotPoint) -> Bool {
        return
            lhs.identifier == rhs.identifier &&
            lhs.location.coordinate == rhs.location.coordinate &&
            lhs.photo == rhs.photo &&
            lhs.time == rhs.time
    }
}
