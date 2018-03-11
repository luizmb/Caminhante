import CommonLibrary
import Foundation
import KleinKit
import UIKit

class ActivityControlsViewController: UIViewController {

    var disposables: [Any] = []
    @IBOutlet weak var locationPermissionLabel: UILabel!
    @IBOutlet weak var healthKitPermissionLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    var allButtons: [UIButton] = []
    @IBOutlet weak var activityInProgressLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        allButtons = [startButton, pauseButton, finishButton, resetButton]
        allButtons.forEach {
            $0.layer.borderColor = UIColor.blue.cgColor
            $0.layer.cornerRadius = 8
            $0.layer.masksToBounds = true
            $0.layer.borderWidth = 1.0
        }

        stateProvider.subscribe { [weak self] state in
            DispatchQueue.main.async {
                self?.update(state: state)
            }
        }.bind(to: self)
    }

    @IBAction func settingsAppTap(_ sender: Any) {
        actionDispatcher.async(LocationActionRequest.reviewPermissions)
    }

    @IBAction func startButtonTap(_ sender: Any) {
        actionDispatcher.async(ActivityActionRequest.startActivity)
    }

    @IBAction func pauseButtonTap(_ sender: Any) {
        actionDispatcher.async(ActivityActionRequest.pauseActivity)
    }

    @IBAction func finishButtonTap(_ sender: Any) {
        actionDispatcher.async(ActivityActionRequest.finishActivity)
    }

    @IBAction func resetButtonTap(_ sender: Any) {
        actionDispatcher.async(ActivityActionRequest.resetActivity)
    }
}

extension ActivityControlsViewController {
    private func update(state: AppState) {
        switch (state.deviceState.locationPermission, state.currentActivity?.state) {
        case (.denied, _):                  enable(buttons: [])
        case (.pending, _):                 enable(buttons: [])
        case (.authorized, .paused?):       enable(buttons: [startButton, finishButton])
        case (.authorized, .inProgress?):   enable(buttons: [pauseButton, finishButton])
        case (.authorized, .finished?):     enable(buttons: [resetButton])
        case (.authorized, nil):            enable(buttons: [startButton])
        }

        allButtons.forEach { $0.isEnabled = state.deviceState.counterPartReachable }
        locationPermissionLabel.text = state.deviceState.locationPermission.englishDescription
        healthKitPermissionLabel.text = state.deviceState.healthPermission.englishDescription
    }

    private func enable(buttons: [UIButton]) {
        allButtons.forEach { $0.isHidden = !buttons.contains($0) }
    }
}

extension ActivityControlsViewController: HasActionDispatcher { }
extension ActivityControlsViewController: HasStateProvider { }
extension ActivityControlsViewController: HasDisposableBag { }
