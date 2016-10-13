//
//  ListViewModel.swift
//  MyWeight
//
//  Created by Diogo on 09/10/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import Foundation

public protocol ListViewModelProtocol {

    var items: UInt { get }
    var data: (_ item: UInt) -> WeightViewModel { get }

    var buttonTitle: String { get }
    //    var noDataTitle: String { get }
    //    var noDataDescription: String { get }

    var didTapAction: () -> Void { get }
    
}

public struct ListViewModel: ListViewModelProtocol {

    public let items: UInt
    public let data: (UInt) -> WeightViewModel

    public let buttonTitle: String
    public let didTapAction: () -> Void

}

extension ListViewModel {

    public init()
    {
        items = 0

        data = { _ in WeightViewModel() }

        buttonTitle = Localization.addButton

        didTapAction = { Log.debug("Add button tap") }

    }

}

extension ListViewModel {

    public init(with weights: [Weight],
                didTap: @escaping () -> Void)
    {
        items = UInt(weights.count)
        data = { WeightViewModel(with: weights[Int($0)], large: $0 == 0) }

        buttonTitle = Localization.addButton

        didTapAction = didTap
    }

}
