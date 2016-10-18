//
//  ListViewController.swift
//  MyWeight
//
//  Created by Diogo on 09/10/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import UIKit

public protocol ListViewControllerDelegate {
    func didTapAddWeight(last weight: Weight?)
}

public class ListViewController: UIViewController {

    let massController: MassController
    var weights: [Weight] = [Weight]() {
        didSet {
            updateView()
        }
    }

    public var delegate: ListViewControllerDelegate?

    var theView: ListView {
        // I don't like this `!` but it's a framework limitation
        return self.view as! ListView
    }

    public required init(with massController: MassController)
    {
        self.massController = massController
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func loadView()
    {
        let view = ListView()
        self.view = view
    }

    public override func viewDidLoad()
    {
        automaticallyAdjustsScrollViewInsets = false
        updateView()
    }

    func updateView()
    {
        let viewModel = ListViewModel(with: weights) { [weak self] in
            self?.tapAddWeight()
        }

        theView.viewModel = viewModel
    }

    public override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)

        loadWeights()
    }

    public override func viewDidLayoutSubviews()
    {
        theView.topOffset = topLayoutGuide.length
    }

    func loadWeights()
    {
        weights.removeAll()

        massController.requestAuthorizatin { [weak self] (error) in
            guard error == nil else {
                Log.debug(error)
                //TODO: Implement a warning/alert/screen saying that we cannot query for Sample data.
                //It's most likely that we don't have access to health data.
                return
            }

            self?.massController.fetchWeights { [weak self] (samples) in

                if samples.isEmpty {
                    Log.debug("No samples")
                }

                self?.weights.append(contentsOf: samples)
            }
        }
    }

    func tapAddWeight()
    {
        let lastWeight = weights.first
        delegate?.didTapAddWeight(last: lastWeight)
    }
}

