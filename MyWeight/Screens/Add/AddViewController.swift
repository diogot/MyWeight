//
//  AddViewController.swift
//  My Weight
//
//  Created by Diogo Tridapalli on 3/27/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import Combine
import HealthService
import UIKit

public protocol AddViewControllerDelegate {
    func didEnd(on viewController: AddViewController)
}

public class AddViewController: UIViewController {

    private let healthService: HealthRepository
    private let startMass: DataPoint<UnitMass>
    private let now: Date

    private var cancellables = Set<AnyCancellable>()

    public required init(with healthService: HealthRepository, startMass: DataPoint<UnitMass>, now: Date = Date())
    {
        self.healthService = healthService
        self.startMass = startMass
        self.now = now
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
        let viewModel = AddViewModel(initialMass: startMass, now: now,
                                     didTapCancel: { [weak self] in self?.didEnd() },
                                     didTapSave: { [weak self] mass in self?.saveMass(mass) })
        // To avoid warnings of autolayout while the view
        // is not resized by the system
        let frame = UIScreen.main.bounds
        let view = AddView(frame: frame, viewModel: viewModel)
        self.view = view
    }

    func saveMass(_ mass: DataPoint<UnitMass>)
    {
        healthService.save(mass)
            .sink(weak: self, receiveCompletion:  { me, completion in
                Log.error(completion.error)
                me.didEnd()
            }).store(in: &cancellables)
    }

    func didEnd() {
        delegate?.didEnd(on: self)
    }
}
