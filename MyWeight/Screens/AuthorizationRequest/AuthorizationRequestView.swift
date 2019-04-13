//
//  AuthorizationRequestView.swift
//  MyWeight
//
//  Created by Diogo on 18/10/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import UIKit

public class AuthorizationRequestView: UIView {

    let textView: TitleDescriptionView = TitleDescriptionView()
    let okButton: TintButton = TintButton()
    let cancelButton: ClearButton = ClearButton()

    let style: StyleProvider = Style()

    public var viewModel: AuthorizationRequestViewModelProtocol = AuthorizationRequestViewModel() {
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

        let space = style.grid
        let padding = style.grid * 2

        textView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textView)

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: contentView.topAnchor),
            textView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            textView.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ])

        okButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(okButton)

        NSLayoutConstraint.activate([
            okButton.topAnchor.constraint(greaterThanOrEqualTo: textView.bottomAnchor, constant: space),
            okButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: padding),
            okButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -padding)
        ])

        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cancelButton)

        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: okButton.bottomAnchor, constant: space),
            cancelButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: padding),
            cancelButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -padding),
            cancelButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        ])

        okButton.addTarget(self,
                           action: #selector(AuthorizationRequestView.okTap),
                           for: .touchUpInside)

        cancelButton.addTarget(self,
                               action: #selector(AuthorizationRequestView.cancelTap),
                               for: .touchUpInside)
    }

    func update()
    {
        textView.viewModel = viewModel
        okButton.title = viewModel.okTitle
        cancelButton.title = viewModel.cancelTitle
    }

    @objc func okTap()
    {
        viewModel.didTapOkAction()
    }

    @objc func cancelTap()
    {
        viewModel.didTapCancelAction()
    }

}
