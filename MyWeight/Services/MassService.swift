//
//  MassService.swift
//  MyWeight
//
//  Created by Diogo Tridapalli on 10/7/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import UIKit
import HealthKit

public class MassService: MassRepository {

    let healthStore: HealthStoreProtocol
    let bodyMass: HKQuantityTypeIdentifier
    let massType: HKQuantityType

    public init(healthStore: HealthStoreProtocol = HKHealthStore())
    {
        self.healthStore = healthStore
        self.bodyMass = HKQuantityTypeIdentifier.bodyMass
        // I don't like this `!`
        self.massType = HKObjectType.quantityType(forIdentifier: self.bodyMass)!

        startObservingMass()
    }

    // MARK: - Fetch

    public func fetch(_ completion: @escaping (_ results: [Mass]) -> Void)
    {
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

    // MARK: - Save

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

    // MARK: - Delete

    public func delete(_ mass: Mass, completion: @escaping (_ error: Error?) -> Void)
    {
        guard case let .permanent(uuid) = mass.status else {
            // WARNING: need an error here
            completion(nil)
            return
        }

        let predicate = HKQuery.predicateForObject(with: uuid)

        healthStore.deleteObjects(of: massType,
                                  predicate: predicate) { (success, deleted, error) in
                                    completion(error)
        }
    }

    // MARK: - Authorization

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

    public func requestAuthorization(_ completion: @escaping (_ error: Error?) -> Void )
    {
        let massSet = Set<HKSampleType>(arrayLiteral: massType)

        healthStore.requestAuthorization(toShare: massSet,
                                         read: massSet)
        { [weak self] (success, error) in
            self?.startObservingMass()
            DispatchQueue.main.async {
                completion(error)
            }
        }
    }

    // MARK: - Observing

    var massObserverStarted = false
    func startObservingMass()
    {
        guard massObserverStarted == false else {
            return
        }

        massObserverStarted = true

        let query = HKObserverQuery(sampleType: massType,
                                    predicate: nil)
        { [weak self] (query, completion, error) in
            guard error == nil else {
                self?.massObserverStarted = false
                self?.startObservingAppOpen()
                return
            }

            NotificationCenter.default.post(name: .MassServiceDidUpdate,
                                            object: self)
            completion()
        }

        healthStore.execute(query)
    }

    var appOpenObserver: NSObjectProtocol? = nil
    func startObservingAppOpen()
    {
        guard authorizationStatus != .authorized,
            appOpenObserver == nil else {
                return
        }

        let center = NotificationCenter.default
        appOpenObserver =
            center.addObserver(forName: .UIApplicationDidBecomeActive,
                               object: nil,
                               queue: .main)
            { [weak self] notification in
                self?.startObservingMass()
                if self?.authorizationStatus == .authorized,
                    let observer = self?.appOpenObserver {
                    NotificationCenter.default.removeObserver(observer)
                }
        }
    }

}

// MARK: - Notifications

extension NSNotification.Name {
    public static let MassServiceDidUpdate: NSNotification.Name =  NSNotification.Name(rawValue: "MassServiceDidUpdate")
}
