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

    var initialMass: Mass { get }
    var now: Date { get }

    var didTapCancel: () -> Void { get }
    var didTapSave: (Mass) -> Void { get }

}

public struct AddViewModel: AddViewModelProtocol {

    public let title: NSAttributedString
    public let saveButtonText: String
    public let cancelButtonText: NSAttributedString

    public let initialMass: Mass
    public let now: Date

    public let didTapCancel: () -> Void
    public let didTapSave: (Mass) -> Void

}

extension AddViewModel {

    public init(initialMass: Mass,
                now: Date,
                didTapCancel: @escaping () -> Void,
                didTapSave: @escaping (Mass) -> Void)
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
