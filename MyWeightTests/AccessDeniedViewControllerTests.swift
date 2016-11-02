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
            
            it("should have the correct layout on iPhone SE") {
                self.viewController.view.frame = CGRect(x: 0, y: 0, width: 320, height: 568)
                expect(self.viewController.view) == snapshot("AccessDeniedViewControllerTests - iPhone SE")
            }
            
            it("should have the correct layout on iPhone 7") {
                self.viewController.view.frame = CGRect(x: 0, y: 0, width: 375, height: 667)
                expect(self.viewController.view) == snapshot("AccessDeniedViewControllerTests - iPhone 7")
            }
            
            it("should have the correct layout on iPhone 7 plus") {
                self.viewController.view.frame = CGRect(x: 0, y: 0, width: 414, height: 736)
                expect(self.viewController.view) == snapshot("AccessDeniedViewControllerTests - iPhone 7 plus")
            }
        }
        
        
    }
}
