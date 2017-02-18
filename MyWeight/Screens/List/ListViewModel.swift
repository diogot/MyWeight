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
    var data: (_ item: UInt) -> MassViewModel { get }

    var buttonTitle: String { get }

    var emptyListViewModel: TitleDescriptionViewModelProtocol? { get }

    var didTapAction: () -> Void { get }

    var deleteAction: (_ item: UInt) -> Void { get }
    
}

public struct ListViewModel: ListViewModelProtocol {

    public let items: UInt
    public let data: (UInt) -> MassViewModel

    public let buttonTitle: String

    public let emptyListViewModel: TitleDescriptionViewModelProtocol?

    public let didTapAction: () -> Void

    public let deleteAction: (UInt) -> Void

}

extension ListViewModel {

    public init()
    {
        items = 0

        data = { _ in MassViewModel() }

        buttonTitle = Localization.addButton

        didTapAction = { Log.debug("Add button tap") }

        deleteAction = { _ in Log.debug("Delete action") }

        emptyListViewModel = EmptyListViewModel()
    }

}

extension ListViewModel {

    public init(with masses: [Mass],
                didTap: @escaping () -> Void,
                deleteMass: @escaping (Mass) -> Void)
    {
        items = UInt(masses.count)
        data = { MassViewModel(with: masses[Int($0)], large: $0 == 0) }

        buttonTitle = Localization.addButton

        didTapAction = didTap

        deleteAction =  { deleteMass(masses[Int($0)]) }

        emptyListViewModel = items == 0 ? EmptyListViewModel() : nil
    }

}
