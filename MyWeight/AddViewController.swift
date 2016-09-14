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

    fileprivate let weightPicker: UIPickerView = UIPickerView()
    fileprivate let datePicker: UIDatePicker = UIDatePicker()

    fileprivate let button: UIButton = UIButton(type: .system)

    fileprivate let healthStore: HKHealthStore
    fileprivate let startWeigth: Double

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

        view.backgroundColor = .white

        view.addSubview(weightPicker)
        weightPicker.translatesAutoresizingMaskIntoConstraints = false
        weightPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        weightPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        weightPicker.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true

        view.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        datePicker.topAnchor.constraint(equalTo: weightPicker.bottomAnchor, constant: 10).isActive = true

        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        button.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 10).isActive = true

        weightPicker.delegate = self
        weightPicker.dataSource = self

        button.setTitle(Localization.defaultSave, for: UIControlState())
        button.addTarget(self,
                         action: #selector(AddViewController.saveMass),
                         for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)

        datePicker.date = Date()
        setWeightPicker(startWeigth)
    }

    fileprivate let weightDigits: Int = 3

    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return weightDigits;
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return 10
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        var text = String(row)

        if component == 2 {
            text = ", " + text + " kg"
        }

        return text
    }

    fileprivate func setWeightPicker(_ weight: Double)
    {
        guard weight < 100 else {
            Log.debug(":w:")
            return
        }

        var decimalWeight: Int = Int(weight * 10)

        for index: Int in 1 ... weightDigits {
            let mod: Int = decimalWeight % Int(pow(10.0, Double(index)))
            let value = mod / Int(pow(10.0, Double(index-1)))
            decimalWeight -= mod

            Log.debug("\(value) - \(index)")
            weightPicker.selectRow(value, inComponent: weightDigits - index, animated: true)
        }
    }

    fileprivate func selectedWeight() -> Double
    {
        var weight: Double = 0

        for index: Int in 0 ..< weightDigits {
            let partialValue = weightPicker.selectedRow(inComponent: index)
            weight += Double(partialValue) * pow(10.0, Double(weightDigits - index - 2))
        }

        return weight
    }

    @objc fileprivate func saveMass()
    {
        guard let massType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)
            else {
                Log.debug("No mass availble")

                return
        }

        let mass: Double = selectedWeight()

        let quantity = HKQuantity(unit: .gramUnit(with: .kilo),
                                  doubleValue: mass)

        let date = datePicker.date

        let metadata = [HKMetadataKeyWasUserEntered:true]
        let sample = HKQuantitySample(type: massType,
                                      quantity: quantity,
                                      start: date,
                                      end: date,
                                      metadata: metadata)

        healthStore.save(sample, withCompletion: { (success, error) in
            Log.debug("Ok = \(success), error = \(error)")
        }) 

        _ = navigationController?.popViewController(animated: true)
    }
}
