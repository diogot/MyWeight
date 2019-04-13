//
//  AccessDeniedView.swift
//  MyWeight
//
//  Created by Diogo on 20/10/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import UIKit

public class AccessDeniedView: UIView {

    let textView: TitleDescriptionView = TitleDescriptionView()
    let stackView: UIStackView = {
        let view = UIStackView()
        view.spacing = Style().grid * 3
        view.axis = .vertical
        return view
    }()
    let okButton: TintButton = TintButton()

    let style: StyleProvider = Style()

    public var viewModel: AccessDeniedViewModelProtocol = AccessDeniedViewModel() {
        didSet {
            update()
        }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUp()
    {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            contentView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor),
            contentView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
        backgroundColor = style.backgroundColor

        let padding = style.grid * 3
        let buttonPadding = style.grid * 2

        textView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textView)
        textView.setContentHuggingPriority(.required, for: .vertical)

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: contentView.topAnchor),
            textView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            textView.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ])

        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        stackView.setContentHuggingPriority(.defaultLow, for: .vertical)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: textView.bottomAnchor),
            stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: padding),
            stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -padding)
        ])

        let guide = UILayoutGuide()
        contentView.addLayoutGuide(guide)
        NSLayoutConstraint.activate([
            guide.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            guide.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            guide.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ])

        okButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(okButton)

        NSLayoutConstraint.activate([
            okButton.topAnchor.constraint(equalTo: guide.bottomAnchor, constant: buttonPadding),
            okButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: buttonPadding),
            okButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -buttonPadding),
            okButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -buttonPadding)
        ])
        okButton.addTarget(self,
                           action: #selector(AccessDeniedView.okTap),
                           for: .touchUpInside)
    }

    func update()
    {
        textView.viewModel = viewModel

        var oldViews = stackView.arrangedSubviews as? [ImageTextView]
        oldViews?.forEach { $0.removeFromSuperview() }
        let newViews = viewModel.steps.map { viewModel -> UIView in
            let view = oldViews?.popLast() ?? ImageTextView()
            view.viewModel = viewModel
            return view
        }
        newViews.forEach { stackView.addArrangedSubview($0) }

        okButton.title = viewModel.okTitle
    }

    @objc func okTap()
    {
        viewModel.didTapOkAction()
    }

}
