//
//  InterfaceController.swift
//  watch Extension
//
//  Created by Diogo Tridapalli on 3/29/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import WatchKit
import Foundation
import HealthKit

class InterfaceController: WKInterfaceController {

    let healthStore: HKHealthStore = HKHealthStore()

    @IBOutlet var weightInterfaceLabel: WKInterfaceLabel!

    var currentWeigth: Double = 0.0

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        weightInterfaceLabel.setText("Loading...")
    }

    override func willActivate() {
        loadCurrentWeight()

        super.willActivate()
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
                    let weight = sample.quantity.doubleValueForUnit(.gramUnitWithMetricPrefix(.Kilo))
                    self.currentWeigth = weight
                    self.weightInterfaceLabel.setText("\(weight)")
                }
            }
        }
        
        self.healthStore.executeQuery(query)
    }

    @IBAction func updateMass()
    {
        pushControllerWithName("updateMass", context: currentWeigth)
    }


    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
