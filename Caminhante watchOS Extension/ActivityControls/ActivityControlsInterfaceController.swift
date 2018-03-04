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
            DispatchQueue.main.async {
                self?.update(state: state)
            }
        }.bind(to: self)
    }

    private func update(state: AppState) {
        switch (state.deviceState.locationPermission, state.currentActivity?.state) {
        case (.denied, _):                  enable(buttons: [])
        case (.pending, _):                 enable(buttons: [])
        case (.authorized, .paused?):       enable(buttons: [startButton, finishButton])
        case (.authorized, .inProgress?):   enable(buttons: [pauseButton, finishButton])
        case (.authorized, .finished?):     enable(buttons: [resetButton])
        case (.authorized, nil):            enable(buttons: [startButton])
        }

        locationPermissionLabel.setText(state.deviceState.locationPermission.englishDescription)
        healthPermissionLabel.setText(state.deviceState.healthPermission.englishDescription)
    }

    func enable(buttons: [WKInterfaceButton]) {
        allButtons.forEach { $0.setEnabled(buttons.contains($0)) }
    }

    @IBAction func startButtonTap() {
        actionDispatcher.async(ActivityActionRequest.startActivity)
    }

    @IBAction func pauseButtonTap() {
        actionDispatcher.async(ActivityActionRequest.pauseActivity)
    }

    @IBAction func finishButtonTap() {
        actionDispatcher.async(ActivityActionRequest.finishActivity)
    }

    @IBAction func resetButtonTap() {
        actionDispatcher.async(ActivityActionRequest.resetActivity)
    }
}

extension ActivityControlsInterfaceController: HasActionDispatcher { }
extension ActivityControlsInterfaceController: HasStateProvider { }
extension ActivityControlsInterfaceController: HasDisposableBag { }
