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
    let viewModel: AddInterfaceControllerViewModel = AddInterfaceControllerViewModel()

    var massOptions: [MassPickerItem] = []

    var currentMass: Measurement<UnitMass> = Mass().value

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        updateView(with: viewModel)

        if let mass = context as? Mass {
            currentMass = mass.value
            populatePicker(with: currentMass)
        } else {
            massRepository.fetch(entries: 1) { [weak self] in
                let mass = $0.first ?? Mass()
                self?.currentMass = mass.value
                self?.populatePicker(with: mass.value)
            }
        }
    }
    
    override func didAppear() {
        super.didAppear()
        interfacePicker.focus()
    }

    func updateView(with viewModel: AddInterfaceControllerViewModel) {
        saveInterfaceButton.setTitle(viewModel.buttonText)
    }

    func populatePicker(with mass: Measurement<UnitMass>) {
        let range = 20

        var massOptions = [MassPickerItem]()
        let massFormatter = viewModel.massFormatter

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
