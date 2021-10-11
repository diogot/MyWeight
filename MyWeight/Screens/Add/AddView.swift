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
    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .wheels
        return picker
    }()
    let saveButton: TintButton = {
        let button = TintButton()
        button.setContentHuggingPriority(.required, for: .vertical)
        return button
    }()
    let cancelButton: UIButton = UIButton(type: .system)

    let titleLabel: UILabel = {
        let label = UILabel()
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()

    let style: StyleProvider = Style()

    public var viewModel: AddViewModelProtocol {
        didSet {
            updateView()
        }
    }

    public init(frame: CGRect, viewModel: AddViewModelProtocol) {
        self.viewModel = viewModel
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

        let topBar = UIView()
        let grid = style.grid

        let bottomLine = UIView()
        bottomLine.backgroundColor = style.separatorColor

        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        topBar.addSubview(bottomLine)

        NSLayoutConstraint.activate([
            bottomLine.leftAnchor.constraint(equalTo: topBar.leftAnchor),
            bottomLine.rightAnchor.constraint(equalTo: topBar.rightAnchor),
            bottomLine.bottomAnchor.constraint(equalTo: topBar.bottomAnchor),
            bottomLine.heightAnchor.constraint(equalToConstant: 1)
        ])

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        topBar.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topBar.topAnchor, constant: grid * 3),
            titleLabel.bottomAnchor.constraint(equalTo: bottomLine.topAnchor, constant: -grid * 3),
            titleLabel.centerXAnchor.constraint(equalTo: topBar.centerXAnchor)
        ])

        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        topBar.addSubview(cancelButton)

        NSLayoutConstraint.activate([
            cancelButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: topBar.leadingAnchor, constant: grid * 2)
        ])

        cancelButton.addTarget(self,
                               action: #selector(AddView.cancelTap),
                               for: .touchUpInside)


        topBar.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(topBar)

        NSLayoutConstraint.activate([
            topBar.topAnchor.constraint(equalTo: contentView.topAnchor),
            topBar.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            topBar.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ])

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.addArrangedSubview(datePicker)
        stackView.addArrangedSubview(massPicker)

        saveButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(saveButton)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topBar.bottomAnchor),
            stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            stackView.bottomAnchor.constraint(equalTo: saveButton.topAnchor),
            saveButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: grid * 2),
            saveButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -grid * 2),
            saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -grid * 2)
        ])
        saveButton.addTarget(self,
                             action: #selector(AddView.saveTap),
                             for: .touchUpInside)
    }

    func updateView()
    {
        massPicker.mass = viewModel.initialMass.value

        datePicker.date = viewModel.now
        datePicker.maximumDate = viewModel.now
        datePicker.setValue(style.textColor, forKey: "textColor")

        titleLabel.attributedText = viewModel.title

        saveButton.title = viewModel.saveButtonText
        cancelButton.setAttributedTitle(viewModel.cancelButtonText,
                                        for: .normal)
    }

    @objc func saveTap()
    {
        let mass = Mass(value: massPicker.mass,
                        date: datePicker.date)
        viewModel.didTapSave(mass)
    }

    @objc func cancelTap()
    {
        viewModel.didTapCancel()
    }

}
