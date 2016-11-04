//
//  MassViewModel.swift
//  MyWeight
//
//  Created by Diogo on 12/10/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import UIKit

public struct MassViewModel {

    public let mass: NSAttributedString
    public let date: NSAttributedString

}

extension MassViewModel {

    public init() {
        mass = NSAttributedString()
        date = NSAttributedString()
    }


    public init(with mass: Mass, large: Bool) {

        let style: StyleProvider = Style()
        let me = type(of: self)

        let massString = me.string(from: mass.value)
        self.mass = NSAttributedString(string: massString,
                                         font: large ? style.title1 : style.title2,
                                         color: style.textColor)



        let date = me.dateFormatterDay.string(from: mass.date)
        let time = me.dateFormatterTime.string(from: mass.date)
        let dateString = "\(date)\n\(time)"

        let dateFont: UIFont
        let dateColor: UIColor

        if large {
            dateFont = style.subhead
            dateColor = style.textColor
        } else {
            dateFont = style.footnote
            dateColor = style.textLightColor
        }

        self.date = NSAttributedString(string: dateString,
                                       font: dateFont,
                                       color: dateColor)
    }

    static func string(from mass: Measurement<UnitMass>) -> String {
        var massString = massFormatter.string(from: mass)

        if massString.isEmpty {
            massString = massKgMassFormatter.string(from: mass)
        }

        return massString
    }

    static let massKgMassFormatter: MeasurementFormatter = {
        let massFormatter = MeasurementFormatter()
        massFormatter.numberFormatter.minimumFractionDigits = 1
        massFormatter.numberFormatter.maximumFractionDigits = 1
        massFormatter.unitOptions = .providedUnit

        return massFormatter
    }()

    static let massFormatter: MeasurementFormatter = {
        let massFormatter = MeasurementFormatter()
        massFormatter.numberFormatter.minimumFractionDigits = 1
        massFormatter.numberFormatter.maximumFractionDigits = 1

        return massFormatter
    }()

    static let dateFormatterFull: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.doesRelativeDateFormatting = true

        return dateFormatter
    }()

    static let dateFormatterDay: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        dateFormatter.doesRelativeDateFormatting = true

        return dateFormatter
    }()

    static let dateFormatterTime: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short

        return dateFormatter
    }()

}
