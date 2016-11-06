//
//  AppCoordinator.swift
//  MyWeight
//
//  Created by Diogo on 09/10/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import UIKit

public class AppCoordinator {

    let navigationController: UINavigationController
    let massService: MassService = MassService()

    public init(with navigationController: UINavigationController)
    {
        navigationController.isNavigationBarHidden = true
        self.navigationController = navigationController
    }

    public func start()
    {
        let controller = ListViewController(with: massService)
        controller.delegate = self
        navigationController.pushViewController(controller, animated: true)
    }

    func startAdd(last mass: Mass?)
    {
        let addViewController = AddViewController(with: massService,
                                                  startMass: mass ?? Mass())
        addViewController.delegate = self
        self.navigationController.present(addViewController,
                                          animated: true,
                                          completion: nil)
    }

    func startAuthorizationRequest()
    {
        let viewController = AuthorizationRequestViewController(with: massService)
        viewController.delegate = self
        self.navigationController.present(viewController,
                                          animated: true,
                                          completion: nil)
    }

    func startAuthorizationDenied()
    {
        let viewController = AccessDeniedViewController()
        viewController.delegate = self
        self.navigationController.present(viewController,
                                          animated: true,
                                          completion: nil)
    }

}


extension AppCoordinator: ListViewControllerDelegate {

    public func didTapAddMeasure(last mass: Mass?)
    {
        switch massService.authorizationStatus {
        case .authorized:
            startAdd(last: mass)
        case .notDetermined:
            startAuthorizationRequest()
        case .denied:
            startAuthorizationDenied()
        }
    }

}

extension AppCoordinator: AddViewControllerDelegate {

    public func didEnd()
    {
        self.navigationController.dismiss(animated: true, completion: nil)
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
