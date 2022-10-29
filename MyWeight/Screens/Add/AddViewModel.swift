//
//  AddViewModel.swift
//  MyWeight
//
//  Created by Diogo on 16/10/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import Foundation
import HealthService

public protocol AddViewModelProtocol {

    var title: NSAttributedString { get }
    var saveButtonText: String { get }
    var cancelButtonText: NSAttributedString { get }

    var initialMass: DataPoint<UnitMass> { get }
    var now: Date { get }

    var didTapCancel: () -> Void { get }
    var didTapSave: (DataPoint<UnitMass>) -> Void { get }

}

public struct AddViewModel: AddViewModelProtocol {

    public let title: NSAttributedString
    public let saveButtonText: String
    public let cancelButtonText: NSAttributedString

    public let initialMass: DataPoint<UnitMass>
    public let now: Date

    public let didTapCancel: () -> Void
    public let didTapSave: (DataPoint<UnitMass>) -> Void

}

extension AddViewModel {

    public init(initialMass: DataPoint<UnitMass>,
                now: Date,
                didTapCancel: @escaping () -> Void,
                didTapSave: @escaping (DataPoint<UnitMass>) -> Void)
    {
        let style = Style()

        title = NSAttributedString(string: Localization.addTitle,
                                   font: style.title3,
                                   color: style.textColor)
        saveButtonText = Localization.saveButton
        cancelButtonText = NSAttributedString(string: Localization.cancelButton,
                                              font: style.subhead,
                                              color: style.textColor)

        self.initialMass = initialMass
        self.now = now
        self.didTapCancel = didTapCancel
        self.didTapSave = didTapSave
    }

}
