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
    var displayedIds: [UUID] = []

    init(table: WKInterfaceTable) {
        self.table = table
    }

    func update(state: [SnapshotPoint]) {
        guard let table = table else { return }

        guard !state.isEmpty else {
            table.setNumberOfRows(1, withRowType: ActivitySnapshotsRowController.reuseIdentifier)
            displayedIds = []
            (table.rowController(at: 0) as? ActivitySnapshotsRowController)?.update(state: nil)
            return
        }

        let newPoints = state.filter {
            !displayedIds.contains($0.identifier) &&
            $0.photo.possibleValue()?.image.possibleValue() != nil
        }

        if table.numberOfRows == 1, displayedIds.isEmpty, !newPoints.isEmpty {
            // Remove placeholder
            table.removeRows(at: IndexSet(integer: 0))
        }

        guard !newPoints.isEmpty else { return }

        WKInterfaceDevice.current().play(.click)
        displayedIds += newPoints.map { $0.identifier }

        newPoints.reversed().forEach { newPoint in
            table.insertRows(at: IndexSet(integer: 0), withRowType: ActivitySnapshotsRowController.reuseIdentifier)
            (table.rowController(at: 0) as? ActivitySnapshotsRowController)?.update(state: newPoint)
        }
    }
}
