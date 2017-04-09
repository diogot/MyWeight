//
//  AddInterfaceController.swift
//  MyWeight
//
//  Created by Diogo on 19/03/17.
//  Copyright © 2017 Diogo Tridapalli. All rights reserved.
//

import WatchKit

class AddInterfaceController: WKInterfaceController {

    @IBOutlet var interfacePicker: WKInterfacePicker!
    @IBOutlet var saveInterfaceButton: WKInterfaceButton!

    let massRepository: MassService = MassService()
    let massFormatter: MeasurementFormatter = {
        let massFormatter = MeasurementFormatter()
        massFormatter.numberFormatter.minimumFractionDigits = 1
        massFormatter.numberFormatter.maximumFractionDigits = 1
        massFormatter.unitOptions = .providedUnit
        return massFormatter
    }()

    var massOptions: [MassPickerItem] = []

    var currentMass: Measurement<UnitMass> = Mass().value

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        if let mass = context as? Mass {
            currentMass = mass.value
            populatePicker(with: currentMass)
        } else {
            massRepository.fetch(entries: 1) { [weak self] in
                if let mass = $0.first {
                    self?.currentMass = mass.value
                    self?.populatePicker(with: mass.value)
                } else {
                    let mass = Mass()
                    self?.currentMass = mass.value
                    self?.populatePicker(with: mass.value)
                }
            }
        }
    }

    func populatePicker(with mass: Measurement<UnitMass>) {
        let range = 20

        var massOptions = [MassPickerItem]()

        for i in -range...range {
            let delta = Measurement(value: 0.1 * Double(i), unit: UnitMass.kilograms)
            let item = MassPickerItem(with: mass + delta, massFormatter: massFormatter)
            massOptions.append(item)
        }

        interfacePicker.setItems(massOptions)
        self.massOptions = massOptions
        interfacePicker.setSelectedItemIndex(range)
    }

    @IBAction func saveAction() {
        let mass = Mass(value: currentMass, date: Date())
        massRepository.save(mass) { [weak self] error in
            if let error = error {
                Log.debug(error)
            }
            self?.pop()
        }
    }

    @IBAction func selectedMass(_ index: Int) {
        currentMass = massOptions[index].mass
    }

    override func willActivate() {
        updateUserActivity(UserActivityService.ActivityType.add.rawValue,
                           userInfo: [:],
                           webpageURL: nil)
        super.willActivate()
    }

    override func didDeactivate() {
        invalidateUserActivity()
        super.didDeactivate()
    }

}
