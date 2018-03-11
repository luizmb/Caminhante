import Foundation
import HealthKit

#if os(watchOS)
public protocol HealthStore: class {
    static func isHealthDataAvailable() -> Bool
    func authorizationStatus(for type: HKObjectType) -> HKAuthorizationStatus
    func requestAuthorization(toShare typesToShare: Set<HKSampleType>?,
                              read typesToRead: Set<HKObjectType>?, completion: @escaping (Bool, Error?) -> Void)
    @available(watchOS 2.0, *)
    func earliestPermittedSampleDate() -> Date
    func save(_ object: HKObject, withCompletion completion: @escaping (Bool, Error?) -> Void)
    func save(_ objects: [HKObject], withCompletion completion: @escaping (Bool, Error?) -> Void)
    func delete(_ object: HKObject, withCompletion completion: @escaping (Bool, Error?) -> Void)
    @available(watchOS 2.0, *)
    func delete(_ objects: [HKObject], withCompletion completion: @escaping (Bool, Error?) -> Void)
    @available(watchOS 2.0, *)
    func deleteObjects(of objectType: HKObjectType,
                       predicate: NSPredicate,
                       withCompletion completion: @escaping (Bool, Int, Error?) -> Void)
    func execute(_ query: HKQuery)
    func stop(_ query: HKQuery)
    @available(watchOS, introduced: 2.0, deprecated: 4.0, message: "No longer supported")
    func splitTotalEnergy(_ totalEnergy: HKQuantity,
                          start startDate: Date,
                          end endDate: Date,
                          resultsHandler: @escaping (HKQuantity?, HKQuantity?, Error?) -> Void)
    @available(watchOS, introduced: 2.0, deprecated: 3.0)
    func dateOfBirth() throws -> Date
    @available(watchOS 3.0, *)
    func dateOfBirthComponents() throws -> DateComponents
    func biologicalSex() throws -> HKBiologicalSexObject
    func bloodType() throws -> HKBloodTypeObject
    @available(watchOS 2.0, *)
    func fitzpatrickSkinType() throws -> HKFitzpatrickSkinTypeObject
    @available(watchOS 3.0, *)
    func wheelchairUse() throws -> HKWheelchairUseObject
    func add(_ samples: [HKSample], to workout: HKWorkout, completion: @escaping (Bool, Error?) -> Void)
    @available(watchOS 2.0, *)
    func start(_ workoutSession: HKWorkoutSession)
    @available(watchOS 2.0, *)
    func end(_ workoutSession: HKWorkoutSession)
    @available(watchOS 3.0, *)
    func pause(_ workoutSession: HKWorkoutSession)
    @available(watchOS 3.0, *)
    func resumeWorkoutSession(_ workoutSession: HKWorkoutSession)
    @available(watchOS 2.0, *)
    func preferredUnits(for quantityTypes: Set<HKQuantityType>,
                        completion: @escaping ([HKQuantityType: HKUnit], Error?) -> Void)
}
#endif

#if os(iOS)
@available(iOS 8.0, *)
public protocol HealthStore: class {
    static func isHealthDataAvailable() -> Bool
    func authorizationStatus(for type: HKObjectType) -> HKAuthorizationStatus
    func requestAuthorization(toShare typesToShare: Set<HKSampleType>?,
                              read typesToRead: Set<HKObjectType>?,
                              completion: @escaping (Bool, Error?) -> Void)
    @available(iOS 9.0, *)
    func handleAuthorizationForExtension(completion: @escaping (Bool, Error?) -> Void)
    @available(iOS 9.0, *)
    func earliestPermittedSampleDate() -> Date
    func save(_ object: HKObject, withCompletion completion: @escaping (Bool, Error?) -> Void)
    func save(_ objects: [HKObject], withCompletion completion: @escaping (Bool, Error?) -> Void)
    func delete(_ object: HKObject, withCompletion completion: @escaping (Bool, Error?) -> Void)
    @available(iOS 9.0, *)
    func delete(_ objects: [HKObject], withCompletion completion: @escaping (Bool, Error?) -> Void)
    @available(iOS 9.0, *)
    func deleteObjects(of objectType: HKObjectType,
                       predicate: NSPredicate,
                       withCompletion completion: @escaping (Bool, Int, Error?) -> Void)
    func execute(_ query: HKQuery)
    func stop(_ query: HKQuery)
    @available(iOS, introduced: 9.0, deprecated: 11.0, message: "No longer supported")
    func splitTotalEnergy(_ totalEnergy: HKQuantity,
                          start startDate: Date,
                          end endDate: Date,
                          resultsHandler: @escaping (HKQuantity?, HKQuantity?, Error?) -> Void)
    @available(iOS, introduced: 8.0, deprecated: 10.0)
    func dateOfBirth() throws -> Date
    @available(iOS 10.0, *)
    func dateOfBirthComponents() throws -> DateComponents
    func biologicalSex() throws -> HKBiologicalSexObject
    func bloodType() throws -> HKBloodTypeObject
    @available(iOS 9.0, *)
    func fitzpatrickSkinType() throws -> HKFitzpatrickSkinTypeObject
    @available(iOS 10.0, *)
    func wheelchairUse() throws -> HKWheelchairUseObject
    func add(_ samples: [HKSample], to workout: HKWorkout, completion: @escaping (Bool, Error?) -> Void)
    @available(iOS 10.0, *)
    func startWatchApp(with workoutConfiguration: HKWorkoutConfiguration,
                       completion: @escaping (Bool, Error?) -> Void)
    func enableBackgroundDelivery(for type: HKObjectType,
                                  frequency: HKUpdateFrequency,
                                  withCompletion completion: @escaping (Bool, Error?) -> Void)
    func disableBackgroundDelivery(for type: HKObjectType,
                                   withCompletion completion: @escaping (Bool, Error?) -> Void)
    func disableAllBackgroundDelivery(completion: @escaping (Bool, Error?) -> Void)
    @available(iOS 8.2, *)
    func preferredUnits(for quantityTypes: Set<HKQuantityType>,
                        completion: @escaping ([HKQuantityType: HKUnit], Error?) -> Void)
}
#endif
