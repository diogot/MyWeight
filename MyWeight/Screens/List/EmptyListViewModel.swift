//
//  EmptyListViewModel.swift
//  MyWeight
//
//  Created by Diogo on 18/10/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import Foundation

public struct EmptyListViewModel: TitleDescriptionViewModelProtocol {

    public let title: NSAttributedString
    public let description: NSAttributedString

}

extension EmptyListViewModel {

    public init() {
        let style: StyleProvider = Style()

        title = NSAttributedString(string: Localization.noDataTitle,
                                   font: style.title1,
                                   color: style.textColor)

        description = NSAttributedString(string: Localization.noDataDescription,
                                         font: style.body,
                                         color: style.textLightColor)
    }

}
