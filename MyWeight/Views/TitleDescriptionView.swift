//
//  TitleDescriptionView.swift
//  MyWeight
//
//  Created by Diogo on 18/10/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import UIKit

public protocol TitleDescriptionViewModelProtocol {

    var title: NSAttributedString { get }
    var description: NSAttributedString { get }
    var flexibleHeight: Bool { get }
    
}

public class TitleDescriptionView: UIView {

    struct EmptyViewModel: TitleDescriptionViewModelProtocol {
        let title: NSAttributedString = NSAttributedString()
        let description: NSAttributedString = NSAttributedString()
        let flexibleHeight: Bool = false
    }

    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.setContentHuggingPriority(.required, for: .vertical)

        return label
    }()

    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.setContentHuggingPriority(.required, for: .vertical)

        return label
    }()

    var bottomFixedConstraint: NSLayoutConstraint?

    let style: StyleProvider = Style()

    public var viewModel: TitleDescriptionViewModelProtocol {
        didSet {
            update()
        }
    }

    override public init(frame: CGRect)
    {
        viewModel = EmptyViewModel()
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

        let bottomGuide = UILayoutGuide()
        contentView.addLayoutGuide(bottomGuide)

        bottomGuide.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor).isActive = true
        bottomGuide.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        bottomGuide.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true

        bottomGuide.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                            constant: -padding).isActive = true

        bottomFixedConstraint =
        bottomGuide.heightAnchor.constraint(equalToConstant: 0)
    }

    func update()
    {
        titleLabel.attributedText = viewModel.title
        descriptionLabel.attributedText = viewModel.description
        bottomFixedConstraint?.isActive = !viewModel.flexibleHeight
    }

}
