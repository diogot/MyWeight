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

    override func awakeWithContext(context: AnyObject?)
    {
        super.awakeWithContext(context)

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

    @IBAction func newSelection(value: Int)
    {
        let item = weightOptions[value]
        currentWeight = item.weight
    }

    @IBAction func save()
    {
        print("\(currentWeight)")
        saveMass(currentWeight)
    }

    func populatePicker(weight: Double) -> Void
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
        let quantityTypeIdentifier = HKQuantityTypeIdentifierBodyMass

        guard let massType = HKObjectType.quantityTypeForIdentifier(quantityTypeIdentifier) else {
            print("No mass availble")

            return;
        }

        let massSet = Set<HKSampleType>(arrayLiteral: massType)
        healthStore.requestAuthorizationToShareTypes(massSet, readTypes: massSet, completion: { (success, error) in
            print("Ok = \(success), error = \(error)")
        })



        let startDate = healthStore.earliestPermittedSampleDate()
        let endDate = NSDate()

        guard let sampleType = HKSampleType.quantityTypeForIdentifier(quantityTypeIdentifier) else {
            fatalError("*** This method should never fail ***")
        }

        let predicate = HKQuery.predicateForSamplesWithStartDate(startDate, endDate: endDate, options: .None)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)

        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: 1, sortDescriptors: [sortDescriptor]) {
            query, results, error in

            guard let samples = results as? [HKQuantitySample] else {
                fatalError("An error occured fetching the user's tracked food. In your app, try to handle this error gracefully. The error was: \(error?.localizedDescription)");
            }

            if samples.isEmpty {
                print("No samples")

                return;
            }

            dispatch_async(dispatch_get_main_queue()) {
                if let sample = samples.first {
                    self.currentWeight = sample.quantity.doubleValueForUnit(.gramUnitWithMetricPrefix(.Kilo))
                    self.populatePicker(self.currentWeight)
                }
            }
        }
        
        self.healthStore.executeQuery(query)
    }

    func saveMass(selectedWeight: Double) -> Void
    {
        guard let massType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)
            else {
                print("No mass availble")

                return;
        }

        let mass: Double = selectedWeight

        let quantity = HKQuantity(unit: .gramUnitWithMetricPrefix(.Kilo),
                                  doubleValue: mass)

        let date = NSDate()

        let metadata = [HKMetadataKeyWasUserEntered:true]
        let sample = HKQuantitySample(type: massType,
                                      quantity: quantity,
                                      startDate: date,
                                      endDate: date,
                                      metadata: metadata)

        healthStore.saveObject(sample) { (success, error) in
            print("Ok = \(success), error = \(error)")
            self.popController()
        }
    }
}

class WeightPickerItem: WKPickerItem {
    var weight: Double = 0.0
}
