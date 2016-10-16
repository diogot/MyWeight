//
//  MassPicker.swift
//  MyWeight
//
//  Created by Diogo on 15/10/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import UIKit

public class MassPicker: UIView {

    public var mass: Measurement<UnitMass> {

        set(mass) {
            setPicker(mass.converted(to: .kilograms).value)
        }

        get {
            var mass: Double = 0

            for index: Int in 0 ..< digits {
                let partialValue = picker.selectedRow(inComponent: index)
                mass += Double(partialValue) * pow(10.0, Double(digits - index - 2))
            }
            
            return Measurement(value: mass, unit: .kilograms)
        }

    }
    let picker: UIPickerView = UIPickerView()

    override public required init(frame: CGRect)
    {
        super.init(frame: frame)
        setUp()
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUp()
    {
        let contentView = self

        picker.delegate = self
        picker.dataSource = self

        contentView.addSubview(picker)
        picker.translatesAutoresizingMaskIntoConstraints = false

        picker.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        picker.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        picker.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        picker.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

    }

    let digits: Int = 4

    func setPicker(_ weight: Double)
    {
        guard weight < pow(10.0, Double(digits - 1)) else {
            Log.debug(":w:")
            return
        }

        var decimalWeight: Int = Int(weight * 10)

        for index: Int in 1 ... digits {
            let mod: Int = decimalWeight % Int(pow(10.0, Double(index)))
            let value = mod / Int(pow(10.0, Double(index-1)))
            decimalWeight -= mod

            Log.debug("\(value) - \(index)")
            picker.selectRow(value,
                             inComponent: digits - index,
                             animated: true)
        }
    }

}

extension MassPicker: UIPickerViewDataSource, UIPickerViewDelegate {

    public func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return digits;
    }

    public func pickerView(_ pickerView: UIPickerView,
                           numberOfRowsInComponent component: Int) -> Int
    {
        return 10
    }

    public func pickerView(_ pickerView: UIPickerView,
                           titleForRow row: Int,
                           forComponent component: Int) -> String?
    {
        var text = String(row)

        if component == digits - 1 {
            text = ", " + text + " kg"
        }

        return text
    }

}
