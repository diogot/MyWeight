//
//  AddInterfaceControllerViewModel.swift
//  MyWeight
//
//  Created by Diogo on 09/04/17.
//  Copyright © 2017 Diogo Tridapalli. All rights reserved.
//

import WatchKit

struct AddInterfaceControllerViewModel {
    let buttonText: String
    let massFormatter: MeasurementFormatter

    init() {
        buttonText = L10n.Add.Button.save

        massFormatter = MeasurementFormatter()
        massFormatter.numberFormatter.minimumFractionDigits = 1
        massFormatter.numberFormatter.maximumFractionDigits = 1
    }
}
