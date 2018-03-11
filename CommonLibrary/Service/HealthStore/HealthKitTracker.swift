import CoreLocation
import Foundation
import HealthKit
import KleinKit

public class HealthKitTracker: NSObject {
    public lazy var healthStore = { healthStoreFactory() }()

    #if os(watchOS)
    var state: WorkoutSessionState?
    #endif

    let monitoredTypes = Set([HKObjectType.workoutType(),
                              HKSeriesType.workoutRoute(),
                              HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
                              HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!])

    public static let shared: HealthKitTracker = {
        let global = HealthKitTracker()
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

    private func getCurrentPermission(for types: Set<HKObjectType>) -> Permission {
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
}

#if os(iOS)
extension HealthKitTracker: HealthTracker {
    // Not needed because the workout will can be triggered by the phone using the regular buttons
    // Could be used to open watchApp remotely, tho.
    public func start() { }
    public func pause() { }
    public func resume() { }
    public func stop() { }
    public func reset() { }
    public func save(from startDate: Date,
                     to endDate: Date,
                     distance: Measurement<UnitLength>,
                     energy: Measurement<UnitEnergy>,
                     locations: [CLLocation]) { }
    public func startAccumulatingData(from startDate: Date) { }
    public func appendLocations(_ locations: [CLLocation]) { }
}
#endif

#if os(watchOS)
extension HealthKitTracker: HealthTracker {
    public func start() {
        guard state == nil else { return }

        state = WorkoutSessionState(healthStore: healthStore)

        guard let state = state else { return }

        state.session.delegate = self
        healthStore.start(state.session)
    }

    public func pause() {
        guard let state = state,
            state.session.state == .running else { return }

        healthStore.pause(state.session)
    }

    public func resume() {
        guard let state = state,
            state.session.state == .paused else { return }

        healthStore.resumeWorkoutSession(state.session)
    }

    public func stop() {
        guard let state = state,
            [HKWorkoutSessionState.paused, .running].contains(state.session.state) else { return }

        healthStore.end(state.session)
    }

    public func reset() {
        guard let state = state else { return }

        if state.session.state == .paused || state.session.state == .running {
            stop()
        }

        self.state = nil
    }
}

// MARK: - Data accumulation

extension HealthKitTracker {
    public func startAccumulatingData(from startDate: Date) {
        startWalkingRunningQuery(from: startDate)
        startActiveEnergyBurnedQuery(from: startDate)
    }

    private func startWalkingRunningQuery(from startDate: Date) {
        let typeIdentifier: HKQuantityTypeIdentifier = .distanceWalkingRunning
        startQuery(ofType: typeIdentifier, from: startDate) { [unowned self] (result: Result<[HKQuantitySample]>) in
            switch result {
            case .failure(let error):
                print("Distance walking running query failed with error: \(String(describing: error))")
            case .success(let samples):
                guard let state = self.state, state.session.state != .paused else { return }

                let distance = samples.reduce(Measurement(value: 0, unit: UnitLength.meters)) { (total, sample) in
                    total + Measurement(value: sample.quantity.doubleValue(for: .meter()), unit: UnitLength.meters)
                }
                self.actionDispatcher.dispatch(ActivityAction.healthTrackerDidWalkDistance(distance))
            }
        }
    }

    private func startActiveEnergyBurnedQuery(from startDate: Date) {
        let typeIdentifier: HKQuantityTypeIdentifier = .activeEnergyBurned
        startQuery(ofType: typeIdentifier, from: startDate) { [unowned self] (result: Result<[HKQuantitySample]>) in
            switch result {
            case .failure(let error):
                print("Active energy burned query failed with error: \(String(describing: error))")
            case .success(let samples):
                guard let state = self.state, state.session.state != .paused else { return }

                let energyBurned = samples.reduce(Measurement(value: 0, unit: UnitEnergy.kilocalories)) { (total, sample) in
                    total + Measurement(value: sample.quantity.doubleValue(for: .kilocalorie()), unit: UnitEnergy.kilocalories)
                }

                self.actionDispatcher.dispatch(ActivityAction.healthTrackerDidBurnEnergy(energyBurned))
            }
        }
    }

    private func startQuery<T: HKSample>(ofType type: HKQuantityTypeIdentifier,
                                         from startDate: Date,
                                         signal: @escaping (Result<[T]>) -> Void) {
        guard state != nil else { return }

        let datePredicate = HKQuery.predicateForSamples(withStart: startDate, end: nil, options: .strictStartDate)
        let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])
        let queryPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [datePredicate, devicePredicate])

        let quantityType = HKObjectType.quantityType(forIdentifier: type)!

        let handler: (HKAnchoredObjectQuery, [HKSample]?, [HKDeletedObject]?, HKQueryAnchor?, Error?) -> Void = {
            _, sample, _, _, error in
            switch (sample as? [T], error) {
            case (let result?, _): signal(.success(result))
            case (_, let error?): signal(.failure(error))
            default: signal(.failure(NSError(domain: "HealthKit inconsistent result", code: 999, userInfo: nil)))
            }
        }

        let query = HKAnchoredObjectQuery(type: quantityType,
                                          predicate: queryPredicate,
                                          anchor: nil,
                                          limit: HKObjectQueryNoLimit,
                                          resultsHandler: handler)
        query.updateHandler = handler
        healthStore.execute(query)

        state?.queries.append(query)
    }

    private func stopAccumulatingData() {
        state?.queries.forEach(healthStore.stop)
        state?.queries.removeAll()
    }
}

// MARK: - Save data
extension HealthKitTracker {
    public func save(from startDate: Date,
                     to endDate: Date,
                     distance: Measurement<UnitLength>,
                     energy: Measurement<UnitEnergy>,
                     locations: [CLLocation]) {
        // Create and save a workout sample
        guard let state = state else { return }

        let configuration = state.session.workoutConfiguration
        var metadata = [String: Any]()
        metadata[HKMetadataKeyIndoorWorkout] = (configuration.locationType == .indoor)

        let workout = HKWorkout(activityType: configuration.activityType,
                                start: startDate,
                                end: endDate,
                                workoutEvents: state.events,
                                totalEnergyBurned: energy.toQuantity(),
                                totalDistance: distance.toQuantity(),
                                metadata: metadata)

        healthStore.save(workout) { success, _ in
            guard success else { return }
            self.addSamples(toWorkout: workout,
                            from: startDate,
                            to: endDate,
                            distance: distance,
                            energy: energy,
                            locations: locations)
        }
    }

    private func addSamples(toWorkout workout: HKWorkout,
                            from startDate: Date,
                            to endDate: Date,
                            distance: Measurement<UnitLength>,
                            energy: Measurement<UnitEnergy>,
                            locations: [CLLocation]) {
        // Create energy and distance samples
        let totalEnergyBurnedSample = HKQuantitySample(type: HKQuantityType.activeEnergyBurned(),
                                                       quantity: energy.toQuantity(),
                                                       start: startDate,
                                                       end: endDate)

        let totalDistanceSample = HKQuantitySample(type: HKQuantityType.distanceWalkingRunning(),
                                                   quantity: distance.toQuantity(),
                                                   start: startDate,
                                                   end: endDate)

        // Add samples to workout
        healthStore.add([totalEnergyBurnedSample, totalDistanceSample], to: workout) { success, error in
            guard success else {
                print("Adding workout subsamples failed with error: \(String(describing: error))")
                return
            }
        }

        // Finish the route with a sync identifier so we can easily update the route later
        var metadata = [String: Any]()
        metadata[HKMetadataKeySyncIdentifier] = UUID().uuidString
        metadata[HKMetadataKeySyncVersion] = NSNumber(value: 1)

        state?.workoutRouteBuilder.finishRoute(with: workout, metadata: metadata) { (workoutRoute, error) in
            if workoutRoute == nil {
                print("Finishing route failed with error: \(String(describing: error))")
            }
        }
    }

    public func appendLocations(_ locations: [CLLocation]) {
        state?.workoutRouteBuilder.insertRouteData(locations) { success, error in
            guard success else {
                print("inserting route data failed with error: \(String(describing: error))")
                return
            }
        }
    }
}

// MARK: - HKWorkoutSessionDelegate
extension HealthKitTracker: HKWorkoutSessionDelegate {
    public func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        print("workout session did fail with error: \(error)")
    }

    public func workoutSession(_ workoutSession: HKWorkoutSession,
                               didChangeTo toState: HKWorkoutSessionState,
                               from fromState: HKWorkoutSessionState,
                               date: Date) {
        switch (fromState, toState) {
        case (.notStarted, .running):
            actionDispatcher.async(ActivityActionRequest.healthTrackerDidStart)
        case (_, .ended):
            actionDispatcher.async(ActivityActionRequest.healthTrackerDidFinish)
        default:
            break
        }
    }

    public func workoutSession(_ workoutSession: HKWorkoutSession, didGenerate event: HKWorkoutEvent) {
        DispatchQueue.main.async {
            self.state?.events.append(event)
        }
    }
}
#endif

extension HealthKitTracker: HasActionDispatcher { }
extension HealthKitTracker: HasHealthStore { }
