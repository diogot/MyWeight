//
//  NoDataView.swift
//  MyWeight
//
//  Created by Diogo on 18/10/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import UIKit

public class NoDataView: UIView {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0

        return label
    }()

    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0

        return label
    }()

    let style: StyleProvider = Style()

    public var viewModel: NoDataViewModelProtocol = NoDataViewModel() {
        didSet {
            update()
        }
    }

    override public init(frame: CGRect)
    {
        super.init(frame: frame)
        setUp()
        update()
    }

    @available(*, unavailable)
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUp()
    {
        let grid = style.grid
        let padding = grid * 3
        let space = grid * 2

        let contentView = self
        contentView.backgroundColor = style.backgroundColor

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)

        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor,
                                        constant: padding).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                            constant: padding).isActive = true
        titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor,
                                             constant: -padding).isActive = true

        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descriptionLabel)

        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                         constant: space).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        descriptionLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor,
                                              constant: -padding).isActive = true
        descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor,
                                            constant: -padding).isActive = true
    }

    func update()
    {
        titleLabel.attributedText = viewModel.title
        descriptionLabel.attributedText = viewModel.description
    }

}
