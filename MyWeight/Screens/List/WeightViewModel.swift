//
//  WeightViewModel.swift
//  MyWeight
//
//  Created by Diogo on 12/10/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import UIKit

public struct WeightViewModel {

    public let weight: NSAttributedString
    public let date: NSAttributedString

}

extension WeightViewModel {

    public init() {
        weight = NSAttributedString()
        date = NSAttributedString()
    }


    public init(with weight: Weight, large: Bool) {

        let style: StyleProvider = Style()
        let me = type(of: self)

        let weightString = me.weightFormatter.string(from: weight.value)
        self.weight = NSAttributedString(string: weightString,
                                         font: large ? style.title1 : style.title2,
                                         color: style.textColor)



        let date = me.dateFormatterDay.string(from: weight.date)
        let time = me.dateFormatterTime.string(from: weight.date)
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

    static let weightFormatter: MeasurementFormatter = {
        let weightFormatter = MeasurementFormatter()
        weightFormatter.numberFormatter.minimumFractionDigits = 1
        weightFormatter.numberFormatter.maximumFractionDigits = 1

        return weightFormatter
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
