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

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        self.setTitle("Photos")

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
            return
        }

        photoTable.setHidden(false)
        noActivityLabel.setHidden(true)
        photoTable.setNumberOfRows(activity.snapshotPoints.count,
                                   withRowType: ActivitySnapshotsRowController.reuseIdentifier)

        activity.snapshotPoints.enumerated().forEach { idx, snapshot in
            guard let controller = photoTable.rowController(at: idx)
                as? ActivitySnapshotsRowController else { return }

            switch snapshot.photo {
            case let .loaded(.success(photo)) where photo.image.possibleValue() != nil:
                controller.photoImageView.setImageData(photo.image.possibleValue()!)
                controller.placeholderImageView.setHidden(true)
                controller.placeholderImageView.setAlpha(0.0)
                controller.photoImageView.setHidden(false)
                controller.photoImageView.setAlpha(1.0)
            default:
                controller.placeholderImageView.setHidden(false)
                controller.placeholderImageView.setAlpha(1.0)
                controller.photoImageView.setHidden(true)
                controller.photoImageView.setAlpha(0.0)
            }
        }
    }
}

extension ActivitySnapshotsInterfaceController: HasActionDispatcher { }
extension ActivitySnapshotsInterfaceController: HasStateProvider { }
extension ActivitySnapshotsInterfaceController: HasDisposableBag { }
