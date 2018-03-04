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

        table.setNumberOfRows(max(state.count, 1),
                              withRowType: ActivitySnapshotsRowController.reuseIdentifier)

        guard let firstRow = table.rowController(at: 0) as? ActivitySnapshotsRowController else { return }
        firstRow.update(state: nil)

        state.enumerated().forEach { idx, snapshot in
            guard let row = table.rowController(at: idx)
                as? ActivitySnapshotsRowController else { return }
            row.update(state: snapshot)
        }
    }
}
