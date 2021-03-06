import CommonLibrary
import Foundation
import KleinKit
import WatchKit

class ActivitySnapshotsInterfaceController: WKInterfaceController {

    var disposables: [Any] = []
    @IBOutlet var photoTable: WKInterfaceTable!
    @IBOutlet var noActivityLabel: WKInterfaceLabel!
    var tableController: ActivitySnapshotsTableController!

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

    override func willActivate() {
        actionDispatcher.dispatch(RouterAction.didNavigate(.activityControls))
    }

    private func update(state: AppState) {
        guard let activity = state.currentActivity else {
            photoTable.setHidden(true)
            noActivityLabel.setHidden(false)
            tableController.update(state: [])
            return
        }

        if state.deviceState.navigation == .activityPhotoStream {
            becomeCurrentPage()
        }

        photoTable.setHidden(false)
        noActivityLabel.setHidden(true)
        tableController.update(state: activity.snapshotPoints)
    }
}

extension ActivitySnapshotsInterfaceController: HasActionDispatcher { }
extension ActivitySnapshotsInterfaceController: HasStateProvider { }
extension ActivitySnapshotsInterfaceController: HasDisposableBag { }
