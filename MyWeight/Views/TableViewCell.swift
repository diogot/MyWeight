//
//  TableViewCell.swift
//  MyWeight
//
//  Created by Diogo on 12/10/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import UIKit

public protocol ViewModelOwner {
    associatedtype ViewModel
    var viewModel: ViewModel { get set }
}

class TableViewCell<View: UIView, ViewModel>: UITableViewCell where View: ViewModelOwner, View.ViewModel == ViewModel {

    private(set) var customView: View

    override public init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        customView = View()

        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(customView)

        customView.setContentHuggingPriority(.required, for: .vertical)
        customView.setContentCompressionResistancePriority(.required, for: .vertical)


        customView.translatesAutoresizingMaskIntoConstraints = false

        customView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        customView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        customView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        customView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
    }

    @available(*, unavailable)
    required public init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }

    // The final here is necessary and it's related to this https://developer.apple.com/swift/blog/?id=27
    final var viewModel: ViewModel {
        get {
            return customView.viewModel
        }

        set(newViewModel) {
            customView.viewModel = newViewModel
        }
    }

}
