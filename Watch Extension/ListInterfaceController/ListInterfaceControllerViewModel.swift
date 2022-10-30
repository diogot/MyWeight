//
//  ListInterfaceControllerViewModel.swift
//  MyWeight
//
//  Created by Diogo on 02/04/17.
//  Copyright © 2017 Diogo Tridapalli. All rights reserved.
//

import Foundation
import HealthService

enum ListInterfaceControllerViewModel {
    case main(String, String)
    case goToIphone(String)

    var buttonText: String {
        switch self {
        case .main:
            return L10n.List.Button.add
        case .goToIphone:
            return L10n.List.Button.done
        }
    }

    var lastEntryText: String {
        return L10n.List.LastEntry.text.uppercased()
    }

    static let massFormatter: MeasurementFormatter = {
        let massFormatter = MeasurementFormatter()
        massFormatter.numberFormatter.minimumFractionDigits = 1
        massFormatter.numberFormatter.maximumFractionDigits = 1

        return massFormatter
    }()

    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.doesRelativeDateFormatting = true

        return dateFormatter
    }()

    static let loading: ListInterfaceControllerViewModel = {
        return .main(L10n.List.Loading.text, "")
    }()

    static let denied: ListInterfaceControllerViewModel = {
        return .goToIphone(L10n.List.Denied.text)
    }()

    static let notDetermined: ListInterfaceControllerViewModel = {
        return .goToIphone(L10n.List.NotDetermined.text)
    }()

    static let noEntry: ListInterfaceControllerViewModel = {
        return .main(L10n.List.NoEntry.text, "")
    }()

    static func mass(_ mass: DataPoint<UnitMass>) -> ListInterfaceControllerViewModel {
        let massText = massFormatter.string(from: mass.value)
        let dateText = dateFormatter.string(from: mass.date)
        return .main(massText, dateText)
    }
}
