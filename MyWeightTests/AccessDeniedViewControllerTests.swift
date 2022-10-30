//
//  AccessDeniedViewControllerTests.swift
//  MyWeight
//
//  Created by Bruno Mazzo on 10/29/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import Nimble
import Nimble_Snapshots
import UIKit
import XCTest

@testable import MyWeight

class AccessDeniedViewControllerTests: XCTestCase {
    
    var viewController: AccessDeniedViewController!
    let snapshotService = SnapshotService()

    override func setUp() {
        super.setUp()
        viewController = AccessDeniedViewController()
        viewController.view.frame = UIScreen.main.bounds
    }

    func testSnapshot() {
        expect(self.viewController.view).to(self.snapshotService.haveSnapshot())
    }
}
