//
//  Mass.swift
//  MyWeight
//
//  Created by Diogo on 12/10/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import Foundation
import HealthKit

public struct Mass {

    public let value: Measurement<UnitMass>
    public let date: Date
    let uuid: UUID?

}

extension Mass {

    init()
    {
        value = Measurement(value: 60, unit: .kilograms)
        date = Date()
        uuid = nil
    }

    init(value: Measurement<UnitMass>, date: Date) {
        self.value = value
        self.date = date
        uuid = nil
    }

    init(with sample: HKQuantitySample)
    {
        value = Measurement(value: sample.quantity.doubleValue(for: .gramUnit(with: .kilo)),
                            unit: UnitMass.kilograms)
        date = sample.startDate
        uuid = sample.uuid
    }

}
