//
//  AddViewController.swift
//  My Weight
//
//  Created by Diogo Tridapalli on 3/27/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import UIKit

public protocol AddViewControllerDelegate {
    func didEnd()
}

public class AddViewController: UIViewController {

    fileprivate let weightPicker: MassPicker = MassPicker()
    fileprivate let datePicker: UIDatePicker = UIDatePicker()

    fileprivate let button: UIButton = UIButton(type: .system)

    fileprivate let weightController: WeightController
    fileprivate let startWeigth: Weight

    public required init(weightController: WeightController, startWeight: Weight)
    {
        self.weightController = weightController
        self.startWeigth = startWeight
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public var delegate: AddViewControllerDelegate?

    override public func viewDidLoad()
    {
        super.viewDidLoad()

        view.backgroundColor = .white

        view.addSubview(weightPicker)
        weightPicker.translatesAutoresizingMaskIntoConstraints = false
        weightPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        weightPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        weightPicker.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true

        view.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        datePicker.topAnchor.constraint(equalTo: weightPicker.bottomAnchor, constant: 10).isActive = true

        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        button.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 10).isActive = true

        button.setTitle(Localization.defaultSave, for: UIControlState())
        button.addTarget(self,
                         action: #selector(AddViewController.saveMass),
                         for: .touchUpInside)
    }

    override public func viewWillAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)

        let date = Date()
        datePicker.date = date
        datePicker.maximumDate = date
        weightPicker.mass = startWeigth.value
    }

    @objc fileprivate func saveMass()
    {
        let weight = Weight(value: weightPicker.mass,
                            date: datePicker.date)

        weightController.save(weight: weight) { (error) in
            Log.debug("Error = \(error)")
        }

        delegate?.didEnd()
    }
}
