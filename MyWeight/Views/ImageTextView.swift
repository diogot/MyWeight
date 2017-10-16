//
//  ImageTextView.swift
//  MyWeight
//
//  Created by Diogo on 20/10/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import UIKit

public protocol ImageTextViewModelProtocol {

    var image: UIImage? { get }
    var text: NSAttributedString? { get }

}

public class ImageTextView: UIView {

    struct EmptyViewModel: ImageTextViewModelProtocol {
        let image: UIImage? = nil
        let text: NSAttributedString? = NSAttributedString()
    }

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        return imageView
    }()
    let textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()

    public var viewModel: ImageTextViewModelProtocol {
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
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUp()
    {
        let contentView = self

        let stackView = UIStackView()
        stackView.spacing = Style().grid * 2

        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)

        stackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(textLabel)
    }

    func update()
    {
        let image = viewModel.image
        imageView.image = image
        imageView.isHidden = image == nil

        let text = viewModel.text
        textLabel.attributedText = text
        textLabel.isHidden = text == nil
    }

}
