//
//  AddInterfaceController.swift
//  MyWeight
//
//  Created by Diogo Tridapalli on 3/29/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import WatchKit
import Foundation
import HealthKit

class AddInterfaceController: WKInterfaceController {

    @IBOutlet var interfacePicker: WKInterfacePicker!

    let healthStore: HKHealthStore = HKHealthStore()

    var currentWeight: Double = 60.0

    var weightOptions: [WeightPickerItem] = []

    override func awake(withContext context: Any?)
    {
        super.awake(withContext: context)

        if let weight = context as? Double {
            currentWeight = weight
            populatePicker(currentWeight)
        } else {
            loadCurrentWeight()
        }
    }

    override func willActivate()
    {
        super.willActivate()
    }

    override func didDeactivate()
    {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func newSelection(_ value: Int)
    {
        let item = weightOptions[value]
        currentWeight = item.weight
    }

    @IBAction func save()
    {
        Log.debug("\(currentWeight)")
        saveMass(currentWeight)
    }

    func populatePicker(_ weight: Double) -> Void
    {
        var weightOptions: [WeightPickerItem] = []

        let range = 20

        for i in -range...range {
            let item = WeightPickerItem()
            let weight = weight+Double(i)*0.1
            item.title = "\(weight) kg"
            item.weight = weight
            weightOptions.append(item)
        }

        interfacePicker.setItems(weightOptions)
        self.weightOptions = weightOptions;
        interfacePicker.setSelectedItemIndex(range)
    }

    func loadCurrentWeight() -> Void {
        let quantityTypeIdentifier = HKQuantityTypeIdentifier.bodyMass

        guard let massType = HKObjectType.quantityType(forIdentifier: quantityTypeIdentifier) else {
            Log.debug("No mass availble")

            return;
        }

        let massSet = Set<HKSampleType>(arrayLiteral: massType)
        healthStore.requestAuthorization(toShare: massSet, read: massSet, completion: { (success, error) in
            Log.debug("Ok = \(success), error = \(error)")
        })



        let startDate = healthStore.earliestPermittedSampleDate()
        let endDate = Date()

        guard let sampleType = HKSampleType.quantityType(forIdentifier: quantityTypeIdentifier) else {
            fatalError("*** This method should never fail ***")
        }

        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: HKQueryOptions())
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)

        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: 1, sortDescriptors: [sortDescriptor]) {
            query, results, error in

            guard let samples = results as? [HKQuantitySample] else {
                fatalError("An error occured fetching the user's tracked food. In your app, try to handle this error gracefully. The error was: \(error?.localizedDescription)");
            }

            if samples.isEmpty {
                Log.debug("No samples")

                return;
            }

            DispatchQueue.main.async {
                if let sample = samples.first {
                    self.currentWeight = sample.quantity.doubleValue(for: .gramUnit(with: .kilo))
                    self.populatePicker(self.currentWeight)
                }
            }
        }
        
        self.healthStore.execute(query)
    }

    func saveMass(_ selectedWeight: Double) -> Void
    {
        guard let massType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)
            else {
                Log.debug("No mass availble")

                return;
        }

        let mass: Double = selectedWeight

        let quantity = HKQuantity(unit: .gramUnit(with: .kilo),
                                  doubleValue: mass)

        let date = Date()

        let metadata = [HKMetadataKeyWasUserEntered:true]
        let sample = HKQuantitySample(type: massType,
                                      quantity: quantity,
                                      start: date,
                                      end: date,
                                      metadata: metadata)

        healthStore.save(sample, withCompletion: { (success, error) in
            Log.debug("Ok = \(success), error = \(error)")
            self.pop()
        }) 
    }
}

class WeightPickerItem: WKPickerItem {
    var weight: Double = 0.0
}
