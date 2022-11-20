//
//  ListViewController.swift
//  MyWeight
//
//  Created by Diogo on 09/10/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import Combine
import HealthService
import UIKit

public protocol ListViewControllerDelegate {
    func didTapAddMeasure(last mass: DataPoint<UnitMass>?)
    func failedToDeleteMass()
}

public class ListViewController: UIViewController {

    private let healthService: HealthRepository
    private var masses = [DataPoint<UnitMass>]() {
        didSet {
            updateView()
        }
    }

    public var delegate: ListViewControllerDelegate?

    private lazy var customView = ListView()

    private var massObserverCancellable: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()
    private var loadMassCancellable: AnyCancellable?

    public required init(with healthService: HealthRepository)
    {
        self.healthService = healthService
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func loadView()
    {
        self.view = customView
    }

    public override func viewDidLoad()
    {
        healthService.authorizationStatusPublisher(for: .mass).sink(weak: self, receiveValue: { me, _ in
            me.observeMassesUpdate()
        }).store(in: &cancellables)
    }

    func updateView()
    {
        let viewModel =
            ListViewModel(with: masses,
                          didTap: { [weak self] in self?.tapAddMass() },
                          deleteMass: { [weak self] in self?.delete($0) })

        customView.viewModel = viewModel
    }

    func observeMassesUpdate()
    {
        massObserverCancellable?.cancel()
        massObserverCancellable = healthService.observeChanges(in: .mass)
            .prepend(())
            .flatMap { [healthService] _ in
                healthService.fetchMass().catchFailureLogAndReplace(with: [])
            }
            .sink(
                weak: self,
                receiveCompletion: { _, completion in
                    if let error = completion.error {
                        Log.error(error)
                    }
                },
                receiveValue: { me, masses in
                    me.masses = masses
                }
            )
    }

    func tapAddMass()
    {
        let mass = masses.first
        delegate?.didTapAddMeasure(last: mass)
    }

    func delete(_ mass: DataPoint<UnitMass>)
    {
        healthService.delete(mass)
            .sink(weak: self, receiveCompletion: { me, completion in
                if let error = completion.error {
                    me.failToDelete(error)
                }
            }).store(in: &cancellables)
    }

    func failToDelete(_ error: Error)
    {
        Log.debug(error)
        delegate?.failedToDeleteMass()
    }
}

