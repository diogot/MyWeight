//
//  AppCoordinator.swift
//  MyWeight
//
//  Created by Diogo on 09/10/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import Combine
import HealthService
import StoreKit
import UIKit

public class AppCoordinator {

    let navigationController: UINavigationController
    private let healthService: HealthRepository = HealthService()
    private var cancellables = Set<AnyCancellable>()

    public init(with navigationController: UINavigationController)
    {
        navigationController.isNavigationBarHidden = true
        self.navigationController = navigationController
    }

    public func start()
    {
        let controller = ListViewController(with: healthService)
        controller.delegate = self
        navigationController.pushViewController(controller, animated: true)
    }

    public func extensionRequestedAuthorization() {
        healthService.requestAuthorizationForExtension(for: .mass)
            .sink(weak: self, receiveCompletion: { _, completion in
                Log.error(completion.error)
            }).store(in: &cancellables)
    }

    let modalTransitionController = ModalTransition()

    func startAdd(last mass: DataPoint<UnitMass>?)
    {
        let addViewController = AddViewController(with: healthService,
                                                  startMass: mass ?? DataPoint<UnitMass>())
        addViewController.delegate = self

        addViewController.modalPresentationStyle = .custom
        addViewController.transitioningDelegate = modalTransitionController

        self.navigationController.present(addViewController,
                                          animated: true)
    }

    func startAuthorizationRequest()
    {
        let viewController = AuthorizationRequestViewController(healthService: healthService)
        viewController.delegate = self
        self.navigationController.present(viewController,
                                          animated: true)
    }

    func startAuthorizationDenied()
    {
        let viewController = AccessDeniedViewController()
        viewController.delegate = self
        self.navigationController.present(viewController,
                                          animated: true)
    }

    func askForReview() {
        if #available(iOS 10.3, *) {
            let key = "PlX0PBfZvIXZWmUvMXN3"
            let defaults = UserDefaults.standard
            let times = defaults.integer(forKey: key) + 1
            defaults.set(times, forKey: key)
            if times % 10 == 0, let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        }
    }
}

extension AppCoordinator: ListViewControllerDelegate {

    public func didTapAddMeasure(last mass: DataPoint<UnitMass>?)
    {
        switch healthService.authorizationStatus(for: .mass) {
        case .authorized:
            startAdd(last: mass)
        case .notDetermined:
            startAuthorizationRequest()
        case .denied:
            startAuthorizationDenied()
        }
    }

    public func failedToDeleteMass() {
        let action = AlertViewModel
            .Action(title: Localization.alertOkButton)
            { $0.presentingViewController?.dismiss(animated: true) }
        let viewModel =
            AlertViewModel(title: Localization.alertFailToDeleteTitle,
                           message: Localization.alertFailToDeleteMessage,
                           actions: [action])
        let alert = UIAlertController(with: viewModel)

        DispatchQueue.main.async {
            self.navigationController.present(alert, animated: true)
        }
    }

}

extension AppCoordinator: AddViewControllerDelegate {

    public func didEnd(on viewController: AddViewController) {
        viewController.dismiss(animated: true, completion: nil)
        askForReview()
    }

}

extension AppCoordinator: AuthorizationRequestViewControllerDelegate {

    public func didFinish(on controller: AuthorizationRequestViewController,
                          with authorized: Bool)
    {
        if authorized {
            controller.dismiss(animated: true, completion: { 
                self.startAdd(last: nil)
            })
        } else {
            controller.dismiss(animated: true, completion: nil)
        }
    }

}

extension AppCoordinator: AccessDeniedViewControllerDelegate {

    public func didFinish(on controller: AccessDeniedViewController)
    {
        controller.dismiss(animated: true, completion: nil)
    }

}
