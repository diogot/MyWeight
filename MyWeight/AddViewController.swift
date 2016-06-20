//
//  AddViewController.swift
//  My Weight
//
//  Created by Diogo Tridapalli on 3/27/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import UIKit
import HealthKit

class AddViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    private let weightPicker: UIPickerView = UIPickerView()
    private let datePicker: UIDatePicker = UIDatePicker()

    private let button: UIButton = UIButton(type: .System)

    private let healthStore: HKHealthStore
    private let startWeigth: Double

    required init(healthStore: HKHealthStore, startWeight: Double = 60.0)
    {
        self.healthStore = healthStore
        self.startWeigth = startWeight
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()

        view.backgroundColor = .whiteColor()

        view.addSubview(weightPicker)
        weightPicker.translatesAutoresizingMaskIntoConstraints = false
        weightPicker.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor, constant: 20).active = true
        weightPicker.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor, constant: -20).active = true
        weightPicker.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor).active = true

        view.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor).active = true
        datePicker.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor).active = true
        datePicker.topAnchor.constraintEqualToAnchor(weightPicker.bottomAnchor, constant: 10).active = true

        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor, constant: 20).active = true
        button.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor, constant: -20).active = true
        button.topAnchor.constraintEqualToAnchor(datePicker.bottomAnchor, constant: 10).active = true

        weightPicker.delegate = self
        weightPicker.dataSource = self

        button.setTitle("Save", forState: .Normal)
        button.addTarget(self,
                         action: #selector(AddViewController.saveMass),
                         forControlEvents: .TouchUpInside)
    }

    override func viewWillAppear(animated: Bool)
    {
        super.viewDidAppear(animated)

        datePicker.date = NSDate()
        setWeightPicker(startWeigth)
    }

    private let weightDigits: Int = 3

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return weightDigits;
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return 10
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        var text = String(row)

        if component == 2 {
            text = ", " + text + " kg"
        }

        return text
    }

    private func setWeightPicker(weight: Double)
    {
        guard weight < 100 else {
            print(":w:")
            return
        }

        var decimalWeight: Int = Int(weight * 10)

        for index: Int in 1 ... weightDigits {
            let mod: Int = decimalWeight % Int(pow(10.0, Double(index)))
            let value = mod / Int(pow(10.0, Double(index-1)))
            decimalWeight -= mod

            print("\(value) - \(index)")
            weightPicker.selectRow(value, inComponent: weightDigits - index, animated: true)
        }
    }

    private func selectedWeight() -> Double
    {
        var weight: Double = 0

        for index: Int in 0 ..< weightDigits {
            let partialValue = weightPicker.selectedRowInComponent(index)
            weight += Double(partialValue) * pow(10.0, Double(weightDigits - index - 2))
        }

        return weight
    }

    @objc private func saveMass()
    {
        guard let massType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)
            else {
                print("No mass availble")

                return
        }

        let mass: Double = selectedWeight()

        let quantity = HKQuantity(unit: .gramUnitWithMetricPrefix(.Kilo),
                                  doubleValue: mass)

        let date = datePicker.date

        let metadata = [HKMetadataKeyWasUserEntered:true]
        let sample = HKQuantitySample(type: massType,
                                      quantity: quantity,
                                      startDate: date,
                                      endDate: date,
                                      metadata: metadata)

        healthStore.saveObject(sample) { (success, error) in
            print("Ok = \(success), error = \(error)")
        }

        navigationController?.popViewControllerAnimated(true)
    }
}
