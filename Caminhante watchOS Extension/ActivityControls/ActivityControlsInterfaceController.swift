//
//  ActivityControlsInterfaceController.swift
//  Caminhante watchOS Extension
//
//  Created by Luiz Rodrigo Martins Barbosa on 03.03.18.
//

import CommonLibrary
import Foundation
import KleinKit
import WatchKit

class ActivityControlsInterfaceController: WKInterfaceController {

    var disposables: [Any] = []
    @IBOutlet private var startButton: WKInterfaceButton!
    @IBOutlet private var pauseButton: WKInterfaceButton!
    @IBOutlet private var finishButton: WKInterfaceButton!
    @IBOutlet private var resetButton: WKInterfaceButton!
    var allButtons: [WKInterfaceButton] = []
    @IBOutlet var locationPermissionLabel: WKInterfaceLabel!
    @IBOutlet var healthPermissionLabel: WKInterfaceLabel!

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        self.setTitle("Controls")
        allButtons = [startButton, pauseButton, finishButton, resetButton]

        stateProvider.subscribe { [weak self] state in
            self?.update(state: state)
        }.bind(to: self)
    }

    private func update(state: AppState) {
        switch (state.deviceState.locationPermission, state.currentActivity?.state) {
        case (.denied, _):
            locationPermissionLabel.setText("Denied")
            enable(buttons: [])
        case (.pending, _):
            locationPermissionLabel.setText("Pending")
            enable(buttons: [])
        case (.authorized, .paused?):
            locationPermissionLabel.setText("Authorized")
            enable(buttons: [startButton, finishButton])
        case (.authorized, .inProgress?):
            locationPermissionLabel.setText("Authorized")
            enable(buttons: [pauseButton, finishButton])
        case (.authorized, .finished?):
            locationPermissionLabel.setText("Authorized")
            enable(buttons: [resetButton])
        case (.authorized, nil):
            locationPermissionLabel.setText("Authorized")
            enable(buttons: [startButton])
        }
    }

    func enable(buttons: [WKInterfaceButton]) {
        allButtons.forEach { $0.setEnabled(buttons.contains($0)) }
    }

    @IBAction func startButtonTap() {
        actionDispatcher.dispatch(ActivityAction.startActivity)
    }

    @IBAction func pauseButtonTap() {
        actionDispatcher.dispatch(ActivityAction.pauseActivity)
    }

    @IBAction func finishButtonTap() {
        actionDispatcher.dispatch(ActivityAction.finishActivity)
    }

    @IBAction func resetButtonTap() {
        actionDispatcher.dispatch(ActivityAction.resetActivity)
    }
}

extension ActivityControlsInterfaceController: HasActionDispatcher { }
extension ActivityControlsInterfaceController: HasStateProvider { }
extension ActivityControlsInterfaceController: HasDisposableBag { }
