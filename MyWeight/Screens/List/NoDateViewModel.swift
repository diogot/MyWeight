//
//  NoDateViewModel.swift
//  MyWeight
//
//  Created by Diogo on 18/10/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import Foundation

public protocol NoDataViewModelProtocol {

    var title: NSAttributedString { get }
    var description: NSAttributedString { get }

}

public struct NoDataViewModel: NoDataViewModelProtocol {

    public let title: NSAttributedString
    public let description: NSAttributedString

}

extension NoDataViewModel {

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
