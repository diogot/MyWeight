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
    let snapshotService = SnapshotService()
    
    override func spec() {
        describe("AccessDeniedViewController") {
            beforeEach {
                self.viewController = AccessDeniedViewController()
                self.viewController.view.frame = UIScreen.main.bounds
            }
            
            it("should have the correct layout") {
                expect(self.viewController.view).to(self.snapshotService.haveSnapshot())
            }
        }
        
        
    }
}
