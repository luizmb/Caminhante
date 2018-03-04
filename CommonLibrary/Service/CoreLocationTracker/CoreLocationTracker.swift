//
//  CoreLocationTracker.swift
//  Caminhante
//
//  Created by Luiz Rodrigo Martins Barbosa on 04.03.18.
//

import CoreLocation
import Foundation
import KleinKit

public class CoreLocationTracker: NSObject, LocationTracker {
    let manager = CLLocationManager()

    public static let shared: LocationTracker = {
        let global = CoreLocationTracker()
        return global
    }()

    override private init() {
        super.init()
        manager.delegate = self
    }

    public func requestAuthorization() {
        guard CLLocationManager.authorizationStatus() == .notDetermined else { return }

        actionDispatcher.dispatch(LocationAction.permissionChanged(newPermission: .pending))
        manager.requestAlwaysAuthorization()
    }

    public func start() {
        manager.allowsBackgroundLocationUpdates = true
        manager.startUpdatingLocation()
    }

    public func stop() {
        manager.allowsBackgroundLocationUpdates = false
        manager.stopUpdatingLocation()
    }
}

extension CoreLocationTracker: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        actionDispatcher.async(WorkoutCoordinator.gotNewLocation(location: location))
    }

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            actionDispatcher.dispatch(LocationAction.permissionChanged(newPermission: .authorized))
        case .notDetermined:
            actionDispatcher.dispatch(LocationAction.permissionChanged(newPermission: .pending))
        case .denied, .restricted:
            actionDispatcher.dispatch(LocationAction.permissionChanged(newPermission: .denied))
        }
    }
}

extension CoreLocationTracker: HasActionDispatcher { }
