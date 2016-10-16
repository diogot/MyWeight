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
    let weightController: WeightController = WeightController()

    public init(with navigationController: UINavigationController)
    {
        navigationController.isNavigationBarHidden = true
        self.navigationController = navigationController
    }

    public func start()
    {
        let controller = ListViewController(with: weightController)
        controller.delegate = self
        navigationController.pushViewController(controller, animated: true)
    }

}


extension AppCoordinator: ListViewControllerDelegate {

    public func didTapAddWeight(last weight: Weight?)
    {
        let addViewController = AddViewController(weightController: weightController,
                                                  startWeight: weight ?? Weight())
        addViewController.delegate = self
        self.navigationController.present(addViewController,
                                          animated: true,
                                          completion: nil)
    }

}

extension AppCoordinator: AddViewControllerDelegate {

    public func didEnd()
    {
        self.navigationController.dismiss(animated: true, completion: nil)
    }

}
