//
//  AuthorizationRequestViewController.swift
//  MyWeight
//
//  Created by Diogo on 18/10/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import UIKit

public protocol AuthorizationRequestViewControllerDelegate {
    func didFinish(on controller: AuthorizationRequestViewController,
                   with authorized: Bool)
}

public class AuthorizationRequestViewController: UIViewController {

    let massService: MassRepository

    public var delegate: AuthorizationRequestViewControllerDelegate?

    var theView: AuthorizationRequestView {
        // I don't like this `!` but it's a framework limitation
        return self.view as! AuthorizationRequestView
    }

    public required init(with massService: MassRepository)
    {
        self.massService = massService
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func loadView()
    {
        let view = AuthorizationRequestView()
        self.view = view
    }

    override public func viewDidLoad()
    {
        let viewModel = AuthorizationRequestViewModel(didTapOkAction:
            { [weak self] in
                self?.tapOk()
            }, didTapCancelAction: { [weak self] in
                self?.tapCancel()
        })

        theView.viewModel = viewModel
    }

    override public func viewDidLayoutSubviews()
    {
        theView.topOffset = topLayoutGuide.length
    }

    func tapOk()
    {
        massService.requestAuthorization { [weak self] error in
            if let error = error {
                Log.debug(error)
            }
            print("start")
            let authorized = self?.massService.authorizationStatus == .authorized
            print("finish")
            self?.didFinish(with: authorized)
        }
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
