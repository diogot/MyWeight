//
//  HealthStoreProtocol.swift
//  HealthService
//
//  Created by Diogo on 27/11/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import Foundation
import HealthKit

public protocol HealthStoreProtocol {

    func requestAuthorization(toShare typesToShare: Set<HKSampleType>?,
                              read typesToRead: Set<HKObjectType>?,
                              completion: @escaping (Bool, Error?) -> Void)

#if os(iOS)
    func handleAuthorizationForExtension(completion: @escaping (Bool, Error?) -> Void)
#endif

    func earliestPermittedSampleDate() -> Date

    func execute(_ query: HKQuery)

    func stop(_ query: HKQuery)

    func save(_ object: HKObject, withCompletion completion: @escaping (Bool, Error?) -> Void)

    func deleteObjects(of objectType: HKObjectType, predicate: NSPredicate, withCompletion completion: @escaping (Bool, Int, Error?) -> Void)

    func authorizationStatus(for type: HKObjectType) -> HKAuthorizationStatus
    static func isHealthDataAvailable() -> Bool

    func preferredUnits(for quantityTypes: Set<HKQuantityType>, completion: @escaping ([HKQuantityType : HKUnit], Error?) -> Void)
}

extension HKHealthStore: HealthStoreProtocol {}
