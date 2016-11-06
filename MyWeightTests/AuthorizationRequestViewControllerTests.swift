//
//  AuthorizationRequestViewControllerTests.swift
//  MyWeight
//
//  Created by Bruno Mazzo on 11/2/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import Quick
import Nimble
import Nimble_Snapshots

@testable import MyWeight

class AuthorizationRequestViewControllerTests: QuickSpec {
    
    var viewController: AuthorizationRequestViewController!
    let snapshoService = SnapshotService()
    
    override func spec() {
        describe("AuthorizationRequestViewController Layout") {
            beforeEach {
                self.viewController = AuthorizationRequestViewController(with: MassService())
            }
            
            it("should have the correct portrait layout on all Sizes") {
                expect(self.viewController.view) == self.snapshoService.snapshot("AuthorizationRequestViewController", sizes: self.snapshoService.iPhonePortraitSizes)
            }
        }
    }
}
