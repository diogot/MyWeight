//
//  MassService.swift
//  MyWeight
//
//  Created by Diogo Tridapalli on 10/7/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import Foundation
import HealthKit

public protocol HealthStoreProtocol {

    func requestAuthorization(toShare typesToShare: Set<HKSampleType>?,
                              read typesToRead: Set<HKObjectType>?,
                              completion: @escaping (Bool, Error?) -> Void)

    func earliestPermittedSampleDate() -> Date

    func execute(_ query: HKQuery)

    func save(_ object: HKObject, withCompletion completion: @escaping (Bool, Error?) -> Void)

    func authorizationStatusForType(_ type: HKObjectType) -> HKAuthorizationStatus
    static func isHealthDataAvailable() -> Bool

}

extension HKHealthStore: HealthStoreProtocol {}


public class MassService: MassRepository {

    let healthStore: HealthStoreProtocol
    let bodyMass: HKQuantityTypeIdentifier
    let massType: HKQuantityType

    public init(healthStore: HealthStoreProtocol = HKHealthStore()) {
        self.healthStore = healthStore
        self.bodyMass = HKQuantityTypeIdentifier.bodyMass
        // I don't like this `!`
        self.massType = HKObjectType.quantityType(forIdentifier: self.bodyMass)!
    }

    public func requestAuthorization(_ completion: @escaping (_ error: Error?) -> Void ) {

        let massSet = Set<HKSampleType>(arrayLiteral: massType)

        healthStore.requestAuthorization(toShare: massSet, read: massSet) { (success, error) in
            DispatchQueue.main.async {
                completion(error)
            }
        }
    }

    public func fetch(_ completion: @escaping (_ results: [Mass]) -> Void) {
        let startDate = healthStore.earliestPermittedSampleDate()
        let endDate = Date()

        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: HKQueryOptions())
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)

        let query = HKSampleQuery(sampleType: massType,
                                  predicate: predicate,
                                  limit: HKObjectQueryNoLimit,
                                  sortDescriptors: [sortDescriptor])
        { query, results, error in
            // WARNING: improve
            guard error == nil else {
                Log.debug(error as Any)

                return
            }

            guard let samples = results as? [HKQuantitySample] else {
                fatalError("An error occured fetching the user's tracked food. In your app, try to handle this error gracefully. The error was: \(error?.localizedDescription)")
            }

            if samples.isEmpty {
                Log.debug("No samples")
            }

            let masses = samples.map { Mass(with: $0) }

            DispatchQueue.main.async {
                completion(masses)
            }
        }

        healthStore.execute(query)
    }

    public func save(_ mass: Mass,
                     completion: @escaping (_ error: Error?) -> Void)
    {
        let quantity = HKQuantity(unit: .gramUnit(with: .kilo),
                                  doubleValue: mass.value.converted(to: .kilograms).value)

        let metadata = [HKMetadataKeyWasUserEntered: true]
        let sample = HKQuantitySample(type: massType,
                                      quantity: quantity,
                                      start: mass.date,
                                      end: mass.date,
                                      metadata: metadata)
        
        healthStore.save(sample) { (success, error) in
            completion(error)
        }
    }

    public enum AuthorizationStatus {

        case notDetermined

        case denied

        case authorized

    }

    public var authorizationStatus: AuthorizationStatus {

        let status: AuthorizationStatus

        switch healthStore.authorizationStatusForType(massType) {
        case .notDetermined:
            status = .notDetermined
        case .sharingDenied:
            status = .denied
        case .sharingAuthorized:
            status = .authorized
        }

        return status
    }
    
}


