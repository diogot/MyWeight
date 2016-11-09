//
//  ListViewController.swift
//  MyWeight
//
//  Created by Diogo on 09/10/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import UIKit

public protocol ListViewControllerDelegate {
    func didTapAddMeasure(last mass: Mass?)
}

public class ListViewController: UIViewController {

    let massRepository: MassRepository
    var masses: [Mass] = [Mass]() {
        didSet {
            updateView()
        }
    }

    public var delegate: ListViewControllerDelegate?

    var theView: ListView {
        // I don't like this `!` but it's a framework limitation
        return self.view as! ListView
    }

    public required init(with massRepository: MassRepository)
    {
        self.massRepository = massRepository
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func loadView()
    {
        // To avoid warnings of autolayout while the view
        // is not resized by the system
        let frame = UIScreen.main.bounds
        let view = ListView(frame: frame)
        self.view = view
    }

    public override func viewDidLoad()
    {
        automaticallyAdjustsScrollViewInsets = false
        updateView()
    }

    func updateView()
    {
        let viewModel = ListViewModel(with: masses) { [weak self] in
            self?.tapAddMass()
        }

        theView.viewModel = viewModel
    }

    public override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)

        loadMasses()
    }

    public override func viewDidLayoutSubviews()
    {
        theView.topOffset = topLayoutGuide.length
    }

    func loadMasses()
    {
        masses.removeAll()

        self.massRepository.fetch { [weak self] (samples) in

            if samples.isEmpty {
                Log.debug("No samples")
            }

            self?.masses.append(contentsOf: samples)
        }
    }

    func tapAddMass()
    {
        let mass = masses.first
        delegate?.didTapAddMeasure(last: mass)
    }
}

