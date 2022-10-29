//
//  AuthorizationRequestViewController.swift
//  MyWeight
//
//  Created by Diogo on 18/10/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import Combine
import HealthService
import UIKit

public protocol AuthorizationRequestViewControllerDelegate {
    func didFinish(on controller: AuthorizationRequestViewController,
                   with authorized: Bool)
}

public class AuthorizationRequestViewController: UIViewController {

    private let healthService: HealthRepository
    public var delegate: AuthorizationRequestViewControllerDelegate?

    private var cancellables = Set<AnyCancellable>()

    private lazy var customView = AuthorizationRequestView()

    public required init(healthService: HealthRepository)
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

    override public func viewDidLoad()
    {
        let viewModel = AuthorizationRequestViewModel(didTapOkAction:
            { [weak self] in
                self?.tapOk()
            }, didTapCancelAction: { [weak self] in
                self?.tapCancel()
        })

        customView.viewModel = viewModel
    }

    func tapOk()
    {
        healthService.requestAuthorization(for: .mass)
            .sink(weak: self, receiveCompletion: { me, completion in
                switch completion {
                    case .failure(let error):
                        Log.debug(error)
                    case .finished:
                        let authrorized = me.healthService.authorizationStatus(for: .mass) == .authorized
                        me.didFinish(with: authrorized)
                }
            }).store(in: &cancellables)
    }

    func tapCancel()
    {
        didFinish(with: false)
    }

    func didFinish(with authorized: Bool)
    {
        self.delegate?.didFinish(on: self, with: authorized)
    }
}
