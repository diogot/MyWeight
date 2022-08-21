//
//  AddViewController.swiftUI.swift
//  MyWeight
//
//  Created by Bruno Mazzo on 21/8/2022.
//  Copyright © 2022 Diogo Tridapalli. All rights reserved.
//

import Foundation
import SwiftUI

public protocol AddViewControllerDelegateSwiftUI {
    func didEnd()
}

class IsPresentingDelegate {
    var delegate: AddViewControllerDelegate?
    var hostingViewController: UIViewController?
    
    func didEnd() {
        if let hostingViewController = hostingViewController {
            self.delegate?.didEnd(on: hostingViewController)
        }
    }
}

public class AddViewControllerSwiftUI: UIHostingController<AnyView> {
    
    public var delegate: AddViewControllerDelegate? {
        didSet {
            isPresentingDelegate.delegate = delegate
        }
    }
    
    private var isPresentingDelegate = IsPresentingDelegate()

    public required init(with massService: MassRepository, startMass: Mass, timezone: TimeZone = TimeZone.current)
    {
        super.init(rootView: AnyView(AddViewFromSwiftUI(massService: massService, delegate: isPresentingDelegate).environment(\.timeZone, timezone)))
        
        isPresentingDelegate.hostingViewController = self
        
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
