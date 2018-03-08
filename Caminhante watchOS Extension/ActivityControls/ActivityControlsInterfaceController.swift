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
    @IBOutlet var distanceLabel: WKInterfaceLabel!
    @IBOutlet var energyLabel: WKInterfaceLabel!

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

        locationPermissionLabel.setTextColor(mapToColor(permission: state.deviceState.locationPermission))
        healthPermissionLabel.setTextColor(mapToColor(permission: state.deviceState.healthPermission))
        distanceLabel.setText(state.currentActivity.map { format(distance: $0.totalDistance) } ?? "-")
        energyLabel.setText(state.currentActivity.map { format(energy: $0.totalEnergyBurned) } ?? "-")
    }

    private func mapToColor(permission: Permission) -> UIColor {
        switch permission {
        case .pending: return .gray
        case .authorized: return .green
        case .denied: return .red
        }
    }

    private func format(distance: Measurement<UnitLength>) -> String {
        let m = distance.converted(to: .meters)
        if m.value >= 1_000 {
            let km = distance.converted(to: .kilometers)
            return "\(format(value: km.value))km"
        } else {
            return "\(format(value: m.value))m"
        }
    }

    private func format(energy: Measurement<UnitEnergy>) -> String {
        let cal = energy.converted(to: .calories)
        if cal.value >= 1_000 {
            let kcal = energy.converted(to: .kilocalories)
            return "\(format(value: kcal.value))kcal"
        } else {
            return "\(format(value: cal.value))cal"
        }
    }

    private func format(value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.maximumFractionDigits = 1
        return formatter.string(from: NSNumber(value: value)) ?? "0"
    }

    override func willActivate() {
        actionDispatcher.dispatch(RouterAction.didNavigate(.activityControls))
    }

    private func enable(buttons: [WKInterfaceButton]) {
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
