//
//  AddView.swift
//  MyWeight
//
//  Created by Diogo on 16/10/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import UIKit

public class AddView: UIView {

    let massPicker: MassPicker = MassPicker()
    let datePicker: UIDatePicker = UIDatePicker()

    let saveButton: TintButton = TintButton()
    let cancelButton: UIButton = UIButton(type: .system)

    let titleLabel: UILabel = UILabel()

    let style: StyleProvider = Style()

    public var viewModel: AddViewModelProtocol = AddViewModel() {
        didSet {
            updateView()
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
        updateView()
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUp()
    {
        let contentView = self
        let topBar = UIView()
        let grid = style.grid

        let bottomLine = UIView()
        bottomLine.backgroundColor = style.separatorColor

        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        topBar.addSubview(bottomLine)

        bottomLine.leftAnchor.constraint(equalTo: topBar.leftAnchor).isActive = true
        bottomLine.rightAnchor.constraint(equalTo: topBar.rightAnchor).isActive = true
        bottomLine.bottomAnchor.constraint(equalTo: topBar.bottomAnchor).isActive = true
        bottomLine.heightAnchor.constraint(equalToConstant: 1).isActive = true

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        topBar.addSubview(titleLabel)

        titleLabel.topAnchor.constraint(equalTo: topBar.topAnchor,
                                        constant: grid * 3).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: bottomLine.topAnchor,
                                           constant: -grid * 3).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: topBar.centerXAnchor).isActive = true

        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        topBar.addSubview(cancelButton)

        cancelButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        cancelButton.leadingAnchor.constraint(equalTo: topBar.leadingAnchor,
                                              constant: grid * 2).isActive = true

        cancelButton.addTarget(self,
                               action: #selector(AddView.cancelTap),
                               for: .touchUpInside)


        topBar.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(topBar)

        topConstraint = topBar.topAnchor.constraint(equalTo: contentView.topAnchor)
        topConstraint?.isActive = true
        topBar.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        topBar.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.addArrangedSubview(datePicker)
        stackView.addArrangedSubview(massPicker)

        saveButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(saveButton)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)

        stackView.topAnchor.constraint(equalTo: topBar.bottomAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: saveButton.topAnchor).isActive = true

        saveButton.leftAnchor.constraint(equalTo: contentView.leftAnchor,
                                         constant: grid * 2).isActive = true
        saveButton.rightAnchor.constraint(equalTo: contentView.rightAnchor,
                                          constant: -grid * 2).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                           constant: -grid * 2).isActive = true

        saveButton.addTarget(self,
                             action: #selector(AddView.saveTap),
                             for: .touchUpInside)

        backgroundColor = style.backgroundColor
    }

    func updateView()
    {
        massPicker.mass = viewModel.initialMass.value

        datePicker.date = viewModel.initialMass.date
        datePicker.maximumDate = viewModel.initialMass.date
        datePicker.setValue(style.textColor, forKey: "textColor")

        titleLabel.attributedText = viewModel.title

        saveButton.title = viewModel.saveButtonText
        cancelButton.setAttributedTitle(viewModel.cancelButtonText,
                                        for: .normal)
    }

    func saveTap()
    {
        let mass = Mass(value: massPicker.mass,
                        date: datePicker.date)
        viewModel.didTapSave(mass)
    }

    func cancelTap()
    {
        viewModel.didTapCancel()
    }

}
