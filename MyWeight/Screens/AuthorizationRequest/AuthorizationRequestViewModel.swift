//
//  AuthorizationRequestViewModel.swift
//  MyWeight
//
//  Created by Diogo on 19/10/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import Foundation

public protocol AuthorizationRequestViewModelProtocol: TitleDescriptionViewModelProtocol  {

    var okTitle: String { get }
    var cancelTitle: String { get }

    var didTapOkAction: () -> Void { get }
    var didTapCancelAction: () -> Void { get }

}

public struct AuthorizationRequestViewModel: AuthorizationRequestViewModelProtocol {

    public let title: NSAttributedString
    public let description: NSAttributedString
    public let flexibleHeight: Bool

    public let okTitle: String
    public let cancelTitle: String

    public let didTapOkAction: () -> Void
    public let didTapCancelAction: () -> Void

}

extension AuthorizationRequestViewModel {

    public init()
    {
        self.init(didTapOkAction: { _ in Log.debug("Ok") },
                  didTapCancelAction: { _ in Log.debug("Cancel" ) })
    }

    public init(didTapOkAction: @escaping () -> Void,
                didTapCancelAction: @escaping () -> Void)
    {
        let style: StyleProvider = Style()

        title = NSAttributedString(string: Localization.authorizationTitle,
                                   font: style.title1,
                                   color: style.textColor)
        var description = NSAttributedString(string: Localization.authorizationDescription,
                                             font: style.body,
                                             color: style.textLightColor)

        description = description.highlight(string: Localization.authorizationDescriptionHighlight1,
                                            font: nil,
                                            color: style.textColor)

        description = description.highlight(string: Localization.authorizationDescriptionHighlight2,
                                            font: nil,
                                            color: style.textColor)

        self.description = description

        flexibleHeight = true

        okTitle = Localization.authorizationOkButton
        cancelTitle = Localization.authorizationCancelButton

        self.didTapOkAction = didTapOkAction
        self.didTapCancelAction = didTapCancelAction
    }

}
