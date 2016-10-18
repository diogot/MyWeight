//
//  AddViewModel.swift
//  MyWeight
//
//  Created by Diogo on 16/10/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import Foundation

public protocol AddViewModelProtocol {

    var title: NSAttributedString { get }
    var saveButtonText: String { get }
    var cancelButtonText: NSAttributedString { get }

    var initialMass: Weight { get }

    var didTapCancel: () -> Void { get }
    var didTapSave: (Weight) -> Void { get }

}

public struct AddViewModel: AddViewModelProtocol {

    public let title: NSAttributedString
    public let saveButtonText: String
    public let cancelButtonText: NSAttributedString

    public let initialMass: Weight

    public let didTapCancel: () -> Void
    public let didTapSave: (Weight) -> Void

}

extension AddViewModel {

    public init()
    {
        let mass = Weight()
        self.init(initialMass: mass,
                  didTapCancel: { _ in Log.debug("Cancel") },
                  didTapSave: { _ in Log.debug("Save") })
    }

    public init(initialMass: Weight,
                didTapCancel: @escaping () -> Void,
                didTapSave: @escaping (Weight) -> Void)
    {
        let style = Style()

        title = NSAttributedString(string: Localization.addTitle,
                                   font: style.body,
                                   color: style.textColor)
        saveButtonText = Localization.saveButton
        cancelButtonText = NSAttributedString(string: Localization.cancelButton,
                                              font: style.subhead,
                                              color: style.textColor)

        self.initialMass = Weight(value: initialMass.value, date: Date())
        self.didTapCancel = didTapCancel
        self.didTapSave = didTapSave
    }

}
