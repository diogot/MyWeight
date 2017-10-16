//
//  AccessDeniedViewModel.swift
//  MyWeight
//
//  Created by Diogo on 20/10/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import UIKit

public protocol AccessDeniedViewModelProtocol: TitleDescriptionViewModelProtocol {

    var steps: [ImageTextViewModelProtocol] { get }

    var okTitle: String { get }
    var didTapOkAction: () -> Void { get }

}

public struct AccessDeniedViewModel: AccessDeniedViewModelProtocol {

    public let title: NSAttributedString
    public let description: NSAttributedString
    public let flexibleHeight: Bool

    public let steps: [ImageTextViewModelProtocol]

    public let okTitle: String
    public let didTapOkAction: () -> Void

}

extension AccessDeniedViewModel {

    public init()
    {
        self.init(didTapOkAction: { Log.debug("Ok") })
    }

    public init(didTapOkAction: @escaping () -> Void)
    {
        let style: StyleProvider = Style()

        title = NSAttributedString(string: Localization.accessDeniedTitle,
                                   font: style.title1,
                                   color: style.textColor)

        var description = NSAttributedString(string: Localization.accessDeniedDescription,
                                             font: style.body,
                                             color: style.textLightColor)

        description = description.highlight(string: Localization.accessDeniedDescriptionHighlight1,
                                            font: nil,
                                            color: style.textColor)
        self.description = description
        flexibleHeight = false


        steps = AccessDeniedViewModel.buildSteps()

        okTitle = Localization.accessDeniedOkButton
        self.didTapOkAction = didTapOkAction
    }


    static func buildSteps() -> [ImageTextViewModelProtocol]
    {
        struct Step: ImageTextViewModelProtocol {
            let image: UIImage?
            let text: NSAttributedString?
        }

        let style = Style()
        let font = style.subhead
        let color = style.textColor

        let configs = [(#imageLiteral(resourceName: "ic-cog"), Localization.accessDeniedSettings),
                       (#imageLiteral(resourceName: "ic-permission"), Localization.accessDeniedPrivacy),
                       (#imageLiteral(resourceName: "ic-health"), Localization.accessDeniedHealth),
                       (#imageLiteral(resourceName: "ic-myweight"), Localization.accessDeniedMyWeight)]

        let steps = configs.map { (image, string) -> Step in
            return Step(image: image,
                        text: NSAttributedString(string: string,
                                                 font: font,
                                                 color: color))
        }

        return steps
    }

}

