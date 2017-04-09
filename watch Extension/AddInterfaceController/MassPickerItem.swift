//
//  MassPickerItem.swift
//  MyWeight
//
//  Created by Diogo on 09/04/17.
//  Copyright © 2017 Diogo Tridapalli. All rights reserved.
//

import WatchKit

class MassPickerItem: WKPickerItem {
    let mass: Measurement<UnitMass>

    init(with mass: Measurement<UnitMass>, massFormatter: MeasurementFormatter) {
        self.mass = mass
        super.init()
        title = massFormatter.string(from: mass)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
