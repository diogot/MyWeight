//
//  AccessDeniedViewController.swift
//  MyWeight
//
//  Created by Diogo on 20/10/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import UIKit

public protocol AccessDeniedViewControllerDelegate {
    func didFinish(on controller: AccessDeniedViewController)
}

public class AccessDeniedViewController: UIViewController {

    public var delegate: AccessDeniedViewControllerDelegate?

    var theView: AccessDeniedView {
        // I don't like this `!` but it's a framework limitation
        return self.view as! AccessDeniedView
    }

    override public func loadView()
    {
        let view = AccessDeniedView()
        self.view = view
    }

    override public func viewDidLoad()
    {
        let viewModel = AccessDeniedViewModel { [weak self] in
            self?.didFinish()
        }

        theView.viewModel = viewModel
    }

    override public func viewDidLayoutSubviews()
    {
        theView.topOffset = topLayoutGuide.length
    }

    func didFinish()
    {
        self.delegate?.didFinish(on: self)
    }

}
