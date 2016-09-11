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

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        weightInterfaceLabel.setText("Loading...")
    }

    override func willActivate() {
        loadCurrentWeight()

        super.willActivate()
    }


    func loadCurrentWeight() -> Void {
        let quantityTypeIdentifier = HKQuantityTypeIdentifier.bodyMass

        guard let massType = HKObjectType.quantityType(forIdentifier: quantityTypeIdentifier) else {
            print("No mass availble")

            return;
        }

        let massSet = Set<HKSampleType>(arrayLiteral: massType)
        healthStore.requestAuthorization(toShare: massSet, read: massSet, completion: { (success, error) in
            print("Ok = \(success), error = \(error)")
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
                print("No samples")

                return;
            }

            DispatchQueue.main.async {
                if let sample = samples.first {
                    let weight = sample.quantity.doubleValue(for: .gramUnit(with: .kilo))
                    self.currentWeigth = weight
                    self.weightInterfaceLabel.setText("\(weight)")
                }
            }
        }
        
        self.healthStore.execute(query)
    }

    @IBAction func updateMass()
    {
        pushController(withName: "updateMass", context: currentWeigth)
    }


    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
