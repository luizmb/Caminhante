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
    public var coordinate: CLLocationCoordinate2D
    public var photo: SyncableResult<Photo>
    public var time: Date

    public init(identifier: UUID = UUID(), coordinate: CLLocationCoordinate2D, photo: SyncableResult<Photo>, time: Date) {
        self.identifier = identifier
        self.coordinate = coordinate
        self.photo = photo
        self.time = time
    }
}

extension SnapshotPoint: Equatable {
    public static func == (lhs: SnapshotPoint, rhs: SnapshotPoint) -> Bool {
        return
            lhs.identifier == rhs.identifier &&
            lhs.coordinate == rhs.coordinate &&
            lhs.photo == rhs.photo &&
            lhs.time == rhs.time
    }
}
