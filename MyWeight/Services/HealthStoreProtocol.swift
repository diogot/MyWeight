//
//  HealthStoreProtocol.swift
//  MyWeight
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

    func earliestPermittedSampleDate() -> Date

    func execute(_ query: HKQuery)

    func save(_ object: HKObject, withCompletion completion: @escaping (Bool, Error?) -> Void)

    func deleteObjects(of objectType: HKObjectType, predicate: NSPredicate, withCompletion completion: @escaping (Bool, Int, Error?) -> Void)
    
    func authorizationStatusForType(_ type: HKObjectType) -> HKAuthorizationStatus
    static func isHealthDataAvailable() -> Bool

    func preferredUnits(for quantityTypes: Set<HKQuantityType>, completion: @escaping ([HKQuantityType : HKUnit], Error?) -> Void)
}

extension HKHealthStore: HealthStoreProtocol {}
