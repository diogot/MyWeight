//
//  MassPicker.swift
//  MyWeight
//
//  Created by Diogo on 15/10/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import UIKit

protocol SwiftUIDelegate {
    func massDidChange(_ :Measurement<UnitMass>)
}

public class MassPicker: UIView {

    enum DisplayUnit: Int {
        case kilogram
        case pounds

        static let count: Int = 2

        var type: UnitMass {
            switch self {
            case .kilogram:
                return .kilograms
            case .pounds:
                return .pounds
            }
        }

        var string: String {
            let formatter = MeasurementFormatter()
            return formatter.string(from: self.type)
        }
    }
    
    var delegate: SwiftUIDelegate?
    
    var currentMass: Measurement<UnitMass> {
        didSet {
            update()
        }
    }

    var unit: DisplayUnit = .kilogram {
        didSet {
            update()
        }
    }

    public var mass: Measurement<UnitMass> {

        set(mass) {
            currentMass = mass
        }

        get {
            return currentMass
        }
    }

    let picker: UIPickerView = UIPickerView()
    let style: StyleProvider = Style()

    override public required init(frame: CGRect)
    {
        currentMass = Measurement(value: 0, unit: .kilograms)
        super.init(frame: frame)
        setUp()
        update()
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

    func update()
    {
        let mass = currentMass.converted(to: unit.type).value

        picker.selectRow(Value.row(for: mass),
                         inComponent: Components.value.rawValue,
                         animated: true)
        picker.selectRow(unit.rawValue,
                         inComponent: Components.unit.rawValue,
                         animated: true)
        
        delegate?.massDidChange(self.currentMass)
    }

    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1

        return formatter
    }()
}

extension MassPicker: UIPickerViewDataSource, UIPickerViewDelegate {

    enum Components: Int {
        case value = 0
        case unit = 1

        static let count: Int = 2
    }

    struct Value {
        static let max: Double = 1000.0

        static func row(for value: Double) -> Int {
            return Int(round(value * 10))
        }

        static func value(for row: Int) -> Double {
            return Double(row)/10.0
        }

    }

    public func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return Components.count;
    }

    public func pickerView(_ pickerView: UIPickerView,
                           numberOfRowsInComponent component: Int) -> Int
    {
        guard let aComponent = Components(rawValue: component) else {
            Log.debug("This should not happen")
            return 0;
        }

        let number: Int

        switch aComponent {
        case .value:
            number = Value.row(for: Value.max) + 1
        case .unit:
            number = DisplayUnit.count
        }

        return number
    }

    public func pickerView(_ pickerView: UIPickerView,
                           attributedTitleForRow row: Int,
                           forComponent component: Int) -> NSAttributedString?
    {
        guard let aComponent = Components(rawValue: component) else {
            Log.debug("This should not happen")
            return nil;
        }

        let text: String

        switch aComponent {
        case .value:
            let value = Value.value(for: row)
            text = numberFormatter.string(from: value as NSNumber) ?? String(value)
        case .unit:
            guard let unit = DisplayUnit(rawValue: row) else {
                Log.debug("This should not happen")
                return nil;
            }
            text = unit.string
        }

        return NSAttributedString(string: text,
                                  font: style.title3,
                                  color: style.textColor)
    }

    public func pickerView(_ pickerView: UIPickerView,
                           didSelectRow row: Int,
                           inComponent component: Int)
    {
        guard let aComponent = Components(rawValue: component) else {
            Log.debug("This should not happen")
            return;
        }

        switch aComponent {
        case .value:
            currentMass = Measurement(value: Value.value(for: row), unit: unit.type)
        case .unit:
            guard let unit = DisplayUnit(rawValue: row) else {
                Log.debug("This should not happen")
                return;
            }
            self.unit = unit
        }

    }

}

extension MassPicker {

    public func pickerView(_ pickerView: UIPickerView,
                           rowHeightForComponent component: Int) -> CGFloat
    {
        return style.grid * 4
    }

    public func pickerView(_ pickerView: UIPickerView,
                           widthForComponent component: Int) -> CGFloat
    {
        guard let aComponent = Components(rawValue: component) else {
            Log.debug("This should not happen")
            return 0;
        }

        let width: CGFloat
        switch aComponent {
        case .value:
            width = style.grid * 20
        case .unit:
            width = style.grid * 11
        }

        return width
    }

}
