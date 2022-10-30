//
//  AuthorizationRequestViewControllerTests.swift
//  MyWeight
//
//  Created by Bruno Mazzo on 11/2/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import Nimble
import Nimble_Snapshots
import UIKit
import XCTest

@testable import MyWeight

class AuthorizationRequestViewControllerTests: XCTestCase {

    var viewController: AuthorizationRequestViewController!
    let snapshotService = SnapshotService()

    override func setUp() {
        super.setUp()
        viewController = AuthorizationRequestViewController(healthService: FakeHealthRepository())
        viewController.view.frame = UIScreen.main.bounds
    }

    func testSnapshot() {
        expect(self.viewController.view).to(self.snapshotService.haveSnapshot())
    }
}
