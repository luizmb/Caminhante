//
//  HealthStore.swift
//  Caminhante
//
//  Created by Luiz Rodrigo Martins Barbosa on 04.03.18.
//

import Foundation
import HealthKit
import KleinKit

public class HealthStore: NSObject, HealthKitTracker {
    let healthStore = HKHealthStore()
    let monitoredTypes = Set([HKObjectType.workoutType(),
                              HKSeriesType.workoutRoute(),
                              HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
                              HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!])

    public static let shared: HealthKitTracker = {
        let global = HealthStore()
        return global
    }()

    override private init() {
        super.init()
    }

    public func requestAuthorization() {
        let currentPermission = getCurrentPermission(for: monitoredTypes)

        actionDispatcher.dispatch(HealthKitAction.permissionChanged(newPermission: currentPermission))

        guard currentPermission == .pending else { return }

        healthStore.requestAuthorization(toShare: monitoredTypes, read: monitoredTypes) { [weak self] success, error in
            guard let sself = self else { return }
            switch (success, error) {
            case (false, _), (_, .some):
                sself.actionDispatcher.dispatch(HealthKitAction.permissionChanged(newPermission: .denied))
            case (true, nil):
                sself.actionDispatcher.dispatch(HealthKitAction.permissionChanged(newPermission: .authorized))
            }
        }
    }

    func getCurrentPermission(for types: Set<HKObjectType>) -> Permission {
        var worstCase = Permission.authorized
        for type in types {
            switch healthStore.authorizationStatus(for: type) {
            case .notDetermined:
                // When any type is pending, return it immediately
                return .pending
            case .sharingDenied:
                // At least one is denied, can't return yet because not determined is more important
                worstCase = .denied
            case .sharingAuthorized:
                // Nothing to change here
                break
            }
        }
        return worstCase
    }

    public func start() {
//        manager.allowsBackgroundLocationUpdates = true
//        manager.startUpdatingLocation()
    }

    public func stop() {
//        manager.allowsBackgroundLocationUpdates = false
//        manager.stopUpdatingLocation()
    }
}

extension HealthStore: HasActionDispatcher { }
