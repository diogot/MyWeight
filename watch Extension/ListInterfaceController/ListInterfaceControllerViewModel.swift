//
//  ListInterfaceControllerViewModel.swift
//  MyWeight
//
//  Created by Diogo on 02/04/17.
//  Copyright © 2017 Diogo Tridapalli. All rights reserved.
//

import Foundation

enum ListInterfaceControllerViewModel {
    case main(String, String)
    case goToIphone(String)


    static let massFormatter: MeasurementFormatter = {
        let massFormatter = MeasurementFormatter()
        massFormatter.numberFormatter.minimumFractionDigits = 1
        massFormatter.numberFormatter.maximumFractionDigits = 1
        massFormatter.unitOptions = .providedUnit

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
        return .main("Loading ...", "")
    }()

    static let denied: ListInterfaceControllerViewModel = {
        return .goToIphone("Health data denied, you need to allow in Health.app at your iPhone")
    }()

    static let notDetermined: ListInterfaceControllerViewModel = {
        return .goToIphone("You need to authorize in your iPhone")
    }()

    static let noEntry: ListInterfaceControllerViewModel = {
        return .main("No entry", "")
    }()

    static func mass(_ mass: Mass) -> ListInterfaceControllerViewModel {
        let massText = massFormatter.string(from: mass.value)
        let dateText = dateFormatter.string(from: mass.date)
        return .main(massText, dateText)
    }
}
