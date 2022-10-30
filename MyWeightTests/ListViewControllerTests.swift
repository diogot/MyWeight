//
//  ListViewControllerTests.swift
//  MyWeight
//
//  Created by Bruno Mazzo on 11/6/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import Foundation
import Nimble
import Nimble_Snapshots
import XCTest

@testable import HealthService
@testable import MyWeight

class ListViewControllerTests: XCTestCase {

    var viewController: ListViewController!
    var massRepositoryMock: FakeHealthRepository!
    let snapshotService = SnapshotService()

    override func setUp() {
        super.setUp()
        massRepositoryMock = FakeHealthRepository()
        viewController = ListViewController(with: massRepositoryMock)
    }

    func testEmpty() {
        expect(self.viewController.view).to(self.snapshotService.haveSnapshot())
    }

    func testWithItems() {
        massRepositoryMock.fetchMassResponse = .success([
            .init(value: 60, date: "10/10/2016 10:10"),
            .init(value: 62, date: "08/10/2016 9:10"),
            .init(value: 64, date: "06/10/2016 11:30"),
            .init(value: 66, date: "02/10/2016 12:00"),
            .init(value: 68, date: "30/09/2016 14:44"),
            .init(value: 70, date: "28/09/2016 16:31"),
            .init(value: 72, date: "26/09/2016 18:20"),
            .init(value: 74, date: "24/09/2016 20:10"),
            .init(value: 76, date: "22/09/2016 22:44")
        ])
        _ = viewController.view
        viewController.viewWillAppear(true)
        viewController.viewDidAppear(true)

        expect(self.viewController.view).to(self.snapshotService.haveSnapshot())
    }
}

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
    return dateFormatter
}()
private extension DataPoint where T == UnitMass {
    init(value: Double, date: String) {
        self.init(kind: .mass, value: Measurement(value: value, unit: .kilograms), date: dateFormatter.date(from: date)!, metadata: nil)
    }
}
