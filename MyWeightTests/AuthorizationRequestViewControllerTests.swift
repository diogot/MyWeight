//
//  AuthorizationRequestViewControllerTests.swift
//  MyWeight
//
//  Created by Bruno Mazzo on 11/2/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import Nimble
import Nimble_Snapshots
import Quick
import UIKit

@testable import MyWeight

class AuthorizationRequestViewControllerTests: QuickSpec {

    var viewController: AuthorizationRequestViewController!
    let snapshotService = SnapshotService()

    override func spec() {
        describe("AuthorizationRequestViewController") {
            beforeEach {
                self.viewController = AuthorizationRequestViewController(healthService: FakeHealthRepository())
                self.viewController.view.frame = UIScreen.main.bounds
            }

            it("should have the correct layout") {
                expect(self.viewController.view).to(self.snapshotService.haveSnapshot())
            }
        }
    }
}
