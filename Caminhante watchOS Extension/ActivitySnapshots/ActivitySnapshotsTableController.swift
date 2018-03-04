//
//  ActivitySnapshotsTableController.swift
//  Caminhante watchOS Extension
//
//  Created by Luiz Rodrigo Martins Barbosa on 04.03.18.
//

import CommonLibrary
import WatchKit

final class ActivitySnapshotsTableController: NSObject {

    weak var table: WKInterfaceTable?

    init(table: WKInterfaceTable) {
        self.table = table
    }

    func update(state: [SnapshotPoint]) {
        guard let table = table else { return }

        let withPhotos = state.filter {
            $0.photo.possibleValue()?.image.possibleValue() != nil
        }

        table.setNumberOfRows(max(withPhotos.count, 1),
                              withRowType: ActivitySnapshotsRowController.reuseIdentifier)

        guard let firstRow = table.rowController(at: 0) as? ActivitySnapshotsRowController else { return }
        guard !withPhotos.isEmpty else {
            firstRow.update(state: nil)
            return
        }

        withPhotos.enumerated().forEach { idx, snapshot in
            guard let row = table.rowController(at: idx)
                as? ActivitySnapshotsRowController else { return }
            row.update(state: snapshot)
        }
    }
}
