//
//  BootstrapActionRequest.swift
//  Caminhante watchOS Extension
//
//  Created by Luiz Rodrigo Martins Barbosa on 03.03.18.
//

import CommonLibrary
import CoreLocation
import HealthKit
import KleinKit
import WatchKit

enum BootstrapActionRequest: ActionRequest {
    case boot

    func execute(getState: @escaping () -> AppState,
                 dispatch: @escaping DispatchFunction,
                 dispatchAsync: @escaping (AnyActionAsync<AppState>) -> Void) {
        switch self {
        case .boot:
            dispatch(RouterAction.didStart)

            requestAccessToHealthKit()
            locationTracker.requestAuthorization()
        }
    }

    private func requestAccessToHealthKit() {
        let healthStore = HKHealthStore()

        let allTypes = Set([HKObjectType.workoutType(),
                            HKSeriesType.workoutRoute(),
                            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
                            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!])

        healthStore.requestAuthorization(toShare: allTypes, read: allTypes) { success, error in
            if !success {
                print(error?.localizedDescription ?? "")
            }
        }
    }
}

extension BootstrapActionRequest: HasLocationTracker { }
