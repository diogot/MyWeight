//
//  AccessDeniedViewControllerTests.swift
//  MyWeight
//
//  Created by Bruno Mazzo on 10/29/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import Quick
import Nimble
import Nimble_Snapshots

@testable import MyWeight

class AccessDeniedViewControllerTests: QuickSpec {
    
    var viewController: AccessDeniedViewController!
    
    override func spec() {
        describe("AccessDeniedViewController Layout") {
            beforeEach {
                self.viewController = AccessDeniedViewController()
            }
            
            it("should have the correct layout on all iPhones") {
                expect(self.viewController.view) == snapshotScreen("AccessDeniedViewControllerTests", sizes: iPhoneSizes)
            }
        }
        
        
    }
}
