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

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        self.setTitle("Controls")

        stateProvider.subscribe { [weak self] state in
            self?.update(state: state)
        }.bind(to: self)
    }

    private func update(state: AppState) {
        switch state.currentActivity?.state {
        case .paused?:
            startButton.setEnabled(true)
            pauseButton.setEnabled(false)
            finishButton.setEnabled(true)
            resetButton.setEnabled(false)
        case .inProgress?:
            startButton.setEnabled(false)
            pauseButton.setEnabled(true)
            finishButton.setEnabled(true)
            resetButton.setEnabled(false)
        case .finished?:
            startButton.setEnabled(false)
            pauseButton.setEnabled(false)
            finishButton.setEnabled(false)
            resetButton.setEnabled(true)
        case nil:
            startButton.setEnabled(true)
            pauseButton.setEnabled(false)
            finishButton.setEnabled(false)
            resetButton.setEnabled(false)
        }
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
