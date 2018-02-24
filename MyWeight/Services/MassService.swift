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

    public enum Error: Swift.Error {
        case unableToDelete
    }

    let healthStore: HealthStoreProtocol
    let bodyMass: HKQuantityTypeIdentifier
    let massType: HKQuantityType

    public init(healthStore: HealthStoreProtocol = HKHealthStore())
    {
        self.healthStore = healthStore
        self.bodyMass = HKQuantityTypeIdentifier.bodyMass
        // I don't like this `!`
        self.massType = HKObjectType.quantityType(forIdentifier: self.bodyMass)!

        #if os(iOS)
            startObservingMass()
        #endif
    }

    // MARK: - Fetch

    public func fetch(_ completion: @escaping (_ results: [Mass]) -> Void) {
        fetch(entries: nil, completion)
    }

    public func fetch(entries: Int? = nil, _ completion: @escaping (_ results: [Mass]) -> Void)
    {
        let startDate = healthStore.earliestPermittedSampleDate()
        let endDate = Date()

        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: HKQueryOptions())
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)

        let query = HKSampleQuery(sampleType: massType,
                                  predicate: predicate,
                                  limit: entries ?? HKObjectQueryNoLimit,
                                  sortDescriptors: [sortDescriptor])
        { query, results, error in
            // WARNING: improve
            guard error == nil else {
                Log.debug(error as Any)

                return
            }

            guard let samples = results as? [HKQuantitySample] else {
                fatalError("Wrong type")
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
                     completion: @escaping (_ error: Swift.Error?) -> Void)
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

    public func delete(_ mass: Mass, completion: @escaping (_ error: Swift.Error?) -> Void)
    {
        guard case let .permanent(uuid) = mass.status else {
            completion(Error.unableToDelete)
            return
        }

        let predicate = HKQuery.predicateForObject(with: uuid)

        healthStore.deleteObjects(of: massType,
                                  predicate: predicate) { (success, deleted, error) in
                                    if deleted == 0 {
                                        completion(Error.unableToDelete)
                                    } else {
                                        completion(error)
                                    }
        }
    }

    // MARK: - Authorization

    public var authorizationStatus: MassRepositoryAuthorizationStatus {

        let status: MassRepositoryAuthorizationStatus

        switch healthStore.authorizationStatus(for: massType) {
        case .notDetermined:
            status = .notDetermined
        case .sharingDenied:
            status = .denied
        case .sharingAuthorized:
            status = .authorized
        }

        return status
    }

    public func requestAuthorization(_ completion: @escaping (_ error: Swift.Error?) -> Void )
    {
        let massSet = Set<HKSampleType>(arrayLiteral: massType)

        healthStore.requestAuthorization(toShare: massSet,
                                         read: massSet)
        { [weak self] (success, error) in
            #if os(iOS)
                self?.startObservingMass()
            #endif
            DispatchQueue.main.async {
                completion(error)
            }
        }
    }

    #if os(iOS)
    public func requestAuthorizationForExtension() {
        healthStore.handleAuthorizationForExtension { [weak self] (success, error) in
            self?.startObservingMass()
            Log.debug("Extension request \(success.description)")
            if let error = error {
                Log.debug(error)
            }
        }
    }
    #endif

    // MARK: - Observing

    var massObserverStarted = false

    @available(watchOS, unavailable)
    func startObservingMass()
    {
        #if os(iOS)
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
        #endif
    }

    var appOpenObserver: NSObjectProtocol? = nil

    @available(watchOS, unavailable)
    func startObservingAppOpen()
    {
        #if os(iOS)
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
        #endif
    }

}

// MARK: - Notifications

extension NSNotification.Name {
    public static let MassServiceDidUpdate: NSNotification.Name =  NSNotification.Name(rawValue: "MassServiceDidUpdate")
}
