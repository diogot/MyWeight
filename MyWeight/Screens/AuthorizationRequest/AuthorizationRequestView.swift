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

    public var topOffset: CGFloat {
        set(topOffset) {
            topConstraint?.constant = topOffset
        }

        get {
            return topConstraint?.constant ?? 0
        }
    }

    var topConstraint: NSLayoutConstraint?

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
        let contentView = self
        let space = style.grid
        let padding = style.grid * 2

        textView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textView)

        topConstraint = textView.topAnchor.constraint(equalTo: contentView.topAnchor)
        topConstraint?.isActive = true
        textView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true

        okButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(okButton)

        okButton.topAnchor.constraint(greaterThanOrEqualTo: textView.bottomAnchor,
                                      constant: space).isActive = true
        okButton.leftAnchor.constraint(equalTo: contentView.leftAnchor,
                                       constant: padding).isActive = true
        okButton.rightAnchor.constraint(equalTo: contentView.rightAnchor,
                                       constant: -padding).isActive = true

        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cancelButton)

        cancelButton.topAnchor.constraint(equalTo: okButton.bottomAnchor,
                                          constant: space).isActive = true
        cancelButton.leftAnchor.constraint(equalTo: contentView.leftAnchor,
                                           constant: padding).isActive = true
        cancelButton.rightAnchor.constraint(equalTo: contentView.rightAnchor,
                                            constant: -padding).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                             constant: -padding).isActive = true

        backgroundColor = style.backgroundColor

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
