//
//  Weight.swift
//  MyWeight
//
//  Created by Diogo on 12/10/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import Foundation

public struct Weight {

    public let value: Measurement<UnitMass>
    public let date: Date

}

extension Weight {

    init()
    {
        value = Measurement(value: 60, unit: .kilograms)
        date = Date()
    }

}
