//
//  AddViewController.swift
//  My Weight
//
//  Created by Diogo Tridapalli on 3/27/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import UIKit

public protocol AddViewControllerDelegate {
    func didEnd(on viewController: AddViewController)
}

public class AddViewController: UIViewController {

    let massService: MassRepository
    let startMass: Mass

    public required init(with massService: MassRepository, startMass: Mass)
    {
        self.massService = massService
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
        // To avoid warnings of autolayout while the view
        // is not resized by the system
        let frame = UIScreen.main.bounds
        let view = AddView(frame: frame)
        self.view = view
    }

    override public func viewWillAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)

        let viewModel =
            AddViewModel(initialMass: startMass,
                         didTapCancel: { [weak self] in self?.didEnd() },
                         didTapSave: { [weak self] mass in self?.saveMass(mass) })

        theView.viewModel = viewModel
    }

    override public func viewDidLayoutSubviews()
    {
        theView.topOffset = topLayoutGuide.length
    }

    func saveMass(_ mass: Mass)
    {
        massService.save(mass) { (error) in
            Log.debug("Error = \(error.debugDescription)")
        }

        didEnd()
    }

    func didEnd() {
        delegate?.didEnd(on: self)
    }
}
