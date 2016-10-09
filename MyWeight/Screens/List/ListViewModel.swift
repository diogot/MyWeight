//
//  ListViewModel.swift
//  MyWeight
//
//  Created by Diogo on 09/10/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import Foundation
import HealthKit

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
