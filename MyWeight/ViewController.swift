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

    private let weightController: WeightController = WeightController()

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
        let addViewController = AddViewController(weightController: weightController,
                                                  startWeight: lastWeight ?? 60.0)
        navigationController?.pushViewController(addViewController, animated: true)
    }

    private func loadWeights()
    {
        weights.removeAll()

        weightController.requestAuthorizatin { [weak self] (error) in
            guard error == nil else {
                Log.debug(error)
                //TODO: Implement a warning/alert/screen saying that we cannot query for Sample data.
                //It's most likely that we don't have access to health data.
                return
            }

            self?.weightController.fetchWeights({ [weak self] (samples) in

                if samples.isEmpty {
                    Log.debug("No samples")
                }

                self?.weights.append(contentsOf: samples)
                self?.tableView.reloadData()
            })
        }
    }
}
