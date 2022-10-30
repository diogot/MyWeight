//
//  AddInterfaceController.swift
//  MyWeight
//
//  Created by Diogo on 19/03/17.
//  Copyright © 2017 Diogo Tridapalli. All rights reserved.
//

import Combine
import HealthService
import WatchKit

class AddInterfaceController: WKInterfaceController {

    @IBOutlet var interfacePicker: WKInterfacePicker!
    @IBOutlet var saveInterfaceButton: WKInterfaceButton!

    private let healthService: HealthRepository = HealthService()
    let viewModel: AddInterfaceControllerViewModel = AddInterfaceControllerViewModel()

    var massOptions: [MassPickerItem] = []

    var currentMass: Measurement<UnitMass> = DataPoint<UnitMass>().value

    private var cancellables = Set<AnyCancellable>()

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        updateView(with: viewModel)

        if let mass = context as? DataPoint<UnitMass> {
            currentMass = mass.value
            populatePicker(with: currentMass)
        } else {
            healthService.fetchMass(entries: 1).first()
                .sink(weak: self, receiveValue: { me, values in
                    let mass = values.first ?? DataPoint<UnitMass>()
                    me.currentMass = mass.value
                    me.populatePicker(with: mass.value)
                })
                .store(in: &cancellables)
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
        let range = 200

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
        let mass = DataPoint<UnitMass>(kind: .mass, value: currentMass, date: Date(), metadata: nil)
        healthService.save(mass)
            .sink(weak: self, receiveCompletion: { me, completion in
                Log.error(completion.error)
                me.pop()
            }).store(in: &cancellables)
    }

    @IBAction func selectedMass(_ index: Int) {
        currentMass = massOptions[index].mass
    }

    override func willActivate() {

        update(.init(activityType: UserActivityService.ActivityType.add.rawValue))
        super.willActivate()
        interfacePicker.focus()
    }

    override func didDeactivate() {
        invalidateUserActivity()
        super.didDeactivate()
    }

}
