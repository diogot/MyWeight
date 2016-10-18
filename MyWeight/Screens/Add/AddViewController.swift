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

    let massController: MassController
    let startMass: Mass

    public required init(with massController: MassController, startMass: Mass)
    {
        self.massController = massController
        self.startMass = startMass
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public var delegate: AddViewControllerDelegate?

    var theView: AddView {
        // I don't like this `!` but it's a framework limitation
        return self.view as! AddView
    }

    override public func loadView()
    {
        let view = AddView()
        self.view = view
    }

    override public func viewWillAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)

        let viewModel =
            AddViewModel(initialMass: startMass,
                         didTapCancel: { [weak self] in self?.delegate?.didEnd() },
                         didTapSave: { [weak self] mass in self?.saveMass(mass) })

        theView.viewModel = viewModel
    }

    public override func viewDidLayoutSubviews()
    {
        theView.topOffset = topLayoutGuide.length
    }

    func saveMass(_ mass: Mass)
    {
        massController.save(mass) { (error) in
            Log.debug("Error = \(error)")
        }

        delegate?.didEnd()
    }
}
