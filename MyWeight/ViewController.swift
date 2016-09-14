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

    private let tableView: UITableView = UITableView(frame: CGRect.zero, style: .grouped)

    private var weights: [HKQuantitySample] = [HKQuantitySample]()

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short

        return formatter
    }()

    override func viewDidLoad()
    {
        super.viewDidLoad()

        tableView.frame = view.frame
        view.addSubview(tableView)

        tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        tableView.dataSource = self
        tableView.delegate = self

        tableView.registerCellClass(UITableViewCell.self)

        let barButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ViewController.tapAddWeight))
        navigationItem.rightBarButtonItem = barButton
    }

    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)

        loadWeights()
    }

    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return weights.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.defaultReuseIdentifier,
                                                               for: indexPath)

        let sample = weights[(indexPath as NSIndexPath).row]

        let date = dateFormatter.string(from: sample.startDate)
        let weight = sample.quantity.doubleValue(for: .gramUnit(with: .kilo))

        cell.textLabel?.text = "\(weight) kg - \(date)"

        return cell
    }

    @objc private func tapAddWeight()
    {
        let lastWeight = weights.first?.quantity.doubleValue(for: .gramUnit(with: .kilo))
        let addViewController = AddViewController(healthStore: healthStore, startWeight: lastWeight ?? 60.0)
        navigationController?.pushViewController(addViewController, animated: true)
    }

    private func loadWeights()
    {
        weights.removeAll()

        let quantityTypeIdentifier = HKQuantityTypeIdentifier.bodyMass

        guard let massType = HKObjectType.quantityType(forIdentifier: quantityTypeIdentifier) else {
            Log.debug("No mass availble")

            return
        }

        let massSet = Set<HKSampleType>(arrayLiteral: massType)
        
        healthStore.requestAuthorization(toShare: massSet, read: massSet, completion: { [weak self] (success, error) in
            if success {
                let startDate = self?.healthStore.earliestPermittedSampleDate()
                let endDate = Date()
                guard let sampleType = HKSampleType.quantityType(forIdentifier: quantityTypeIdentifier) else {
                    fatalError("*** This method should never fail ***")
                }
                
                let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: HKQueryOptions())
                let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
                
                let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortDescriptor]) {
                    query, results, error in
                    
                    guard let samples = results as? [HKQuantitySample] else {
                        fatalError("An error occured fetching the user's tracked food. In your app, try to handle this error gracefully. The error was: \(error?.localizedDescription)")
                    }
                    
                    if samples.isEmpty {
                        Log.debug("No samples")
                    }
                    
                    DispatchQueue.main.async {
                        self?.weights.append(contentsOf: samples)
                        self?.tableView.reloadData()
                    }
                }
                self?.healthStore.execute(query)
            } else { //Error
                //This shouldn't be necessary, since success == false
                if let error = error {
                    Log.debug(error)
                    //TODO: Implement a warning/alert/screen saying that we cannot query for Sample data.
                    //It's most likely that we don't have access to health data.
                }
            }
        })
    }
}
