//
//  ListViewController.swift
//  MyWeight
//
//  Created by Diogo on 09/10/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import UIKit
import HealthKit

public class ListViewController: UIViewController {

    let weightController: WeightController = WeightController()
    var weights: [HKQuantitySample] = [HKQuantitySample]() {
        didSet {
            updateView()
        }
    }

    var theView: ListView {
        // I don't like this `!` but it's a framework limitation
        return self.view as! ListView
    }

    public override func loadView()
    {
        let view = ListView()
        self.view = view
        updateView()
    }

    public override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        loadWeights()
    }

    func loadWeights()
    {
        weights.removeAll()

        weightController.requestAuthorizatin { [weak self] (error) in
            guard error == nil else {
                Log.debug(error)
                //TODO: Implement a warning/alert/screen saying that we cannot query for Sample data.
                //It's most likely that we don't have access to health data.
                return
            }

            self?.weightController.fetchWeights { [weak self] (samples) in

                if samples.isEmpty {
                    Log.debug("No samples")
                }

                self?.weights.append(contentsOf: samples)
            }
        }
    }

    func tapAddWeight()
    {
        let lastWeight = weights.first?.quantity.doubleValue(for: .gramUnit(with: .kilo))
        let addViewController = AddViewController(weightController: weightController,
                                                  startWeight: lastWeight ?? 60.0)
        self.navigationController?.pushViewController(addViewController,
                                                      animated: true)
    }

    func updateView()
    {
        let viewModel = ListViewModel(with: weights) { [weak self] in
            self?.tapAddWeight()
        }

        theView.viewModel = viewModel
    }
}

public struct ListViewModel: ListViewModelProtocol {

    public let items: UInt
    public let data: (UInt) -> (weight: Double, date: String)

    public let buttonTitle: String
    public let didTapAction: () -> Void

}

extension ListViewModel {

    public init(with weights: [HKQuantitySample],
                didTap: @escaping () -> Void)
    {
        let me = type(of: self)

        items = UInt(weights.count)
        data = { item in
            let sample = weights[Int(item)]

            let date = me.dateFormatter.string(from: sample.startDate)
            let weight = sample.quantity.doubleValue(for: .gramUnit(with: .kilo))

            return (weight, date)
        }

        buttonTitle = Localization.addButton

        didTapAction = didTap
    }

    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short

        return formatter
    }()

}


