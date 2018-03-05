//
//  ActivitySnapshotsInterfaceController.swift
//  Caminhante watchOS Extension
//
//  Created by Luiz Rodrigo Martins Barbosa on 03.03.18.
//

import CommonLibrary
import Foundation
import KleinKit
import WatchKit

class ActivitySnapshotsInterfaceController: WKInterfaceController {

    var disposables: [Any] = []
    @IBOutlet var photoTable: WKInterfaceTable!
    @IBOutlet var noActivityLabel: WKInterfaceLabel!
    var tableController: ActivitySnapshotsTableController!
    var lastKnownActivityState = ActivityState.finished

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        self.setTitle("Photos")
        tableController = ActivitySnapshotsTableController(table: photoTable)

        stateProvider.subscribe { [weak self] state in
            DispatchQueue.main.async {
                self?.update(state: state)
            }
        }.bind(to: self)
    }

    private func update(state: AppState) {
        guard let activity = state.currentActivity else {
            photoTable.setHidden(true)
            noActivityLabel.setHidden(false)
            tableController.update(state: [])
            return
        }

        // TODO: Navigation should be done via proper routing state
        if lastKnownActivityState != .inProgress && activity.state == .inProgress {
            self.becomeCurrentPage()
        }

        photoTable.setHidden(false)
        noActivityLabel.setHidden(true)
        tableController.update(state: activity.snapshotPoints)
    }
}

extension ActivitySnapshotsInterfaceController: HasActionDispatcher { }
extension ActivitySnapshotsInterfaceController: HasStateProvider { }
extension ActivitySnapshotsInterfaceController: HasDisposableBag { }
