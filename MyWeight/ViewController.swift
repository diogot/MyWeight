//
//  ViewController.swift
//  MyWeight
//
//  Created by Diogo Tridapalli on 3/29/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import UIKit
import HealthKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let healthStore: HKHealthStore = HKHealthStore()

    private let tableView: UITableView = UITableView(frame: CGRect.zero, style: .Grouped)

    private var weights: [HKQuantitySample] = [HKQuantitySample]()

    private let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .ShortStyle

        return formatter
    }()

    override func viewDidLoad()
    {
        super.viewDidLoad()

        tableView.frame = view.frame
        view.addSubview(tableView)

        tableView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        tableView.dataSource = self
        tableView.delegate = self

        tableView.registerClass(UITableViewCell.self,
                                forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))

        let barButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(ViewController.tapAddWeight))
        navigationItem.rightBarButtonItem = barButton
    }

    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)

        loadWeights()
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return weights.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(UITableViewCell.self),
                                                               forIndexPath: indexPath)

        let sample = weights[indexPath.row]

        let date = dateFormatter.stringFromDate(sample.startDate)
        let weight = sample.quantity.doubleValueForUnit(.gramUnitWithMetricPrefix(.Kilo))

        cell.textLabel?.text = "\(weight) kg - \(date)"

        return cell
    }

    @objc private func tapAddWeight()
    {
        let lastWeight = weights.first?.quantity.doubleValueForUnit(.gramUnitWithMetricPrefix(.Kilo))
        let addViewController = AddViewController(healthStore: healthStore, startWeight: lastWeight ?? 60.0)
        navigationController?.pushViewController(addViewController, animated: true)
    }

    private func loadWeights()
    {
        weights.removeAll()

        let quantityTypeIdentifier = HKQuantityTypeIdentifierBodyMass

        guard let massType = HKObjectType.quantityTypeForIdentifier(quantityTypeIdentifier) else {
            print("No mass availble")

            return
        }

        let massSet = Set<HKSampleType>(arrayLiteral: massType)
        
        healthStore.requestAuthorizationToShareTypes(massSet, readTypes: massSet, completion: { [weak self] (success, error) in
            if success {
                let startDate = self?.healthStore.earliestPermittedSampleDate()
                let endDate = NSDate()
                guard let sampleType = HKSampleType.quantityTypeForIdentifier(quantityTypeIdentifier) else {
                    fatalError("*** This method should never fail ***")
                }
                
                let predicate = HKQuery.predicateForSamplesWithStartDate(startDate, endDate: endDate, options: .None)
                let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
                
                let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortDescriptor]) {
                    query, results, error in
                    
                    guard let samples = results as? [HKQuantitySample] else {
                        fatalError("An error occured fetching the user's tracked food. In your app, try to handle this error gracefully. The error was: \(error?.localizedDescription)")
                    }
                    
                    if samples.isEmpty {
                        print("No samples")
                    }
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self?.weights.appendContentsOf(samples)
                        self?.tableView.reloadData()
                    }
                }
                self?.healthStore.executeQuery(query)
            } else { //Error
                //This shouldn't be necessary, since success == false
                if let error = error {
                    print(error)
                    //TODO: Implement a warning/alert/screen saying that we cannot query for Sample data.
                    //It's most likely that we don't have access to health data.
                }
            }
        })
    }
}
