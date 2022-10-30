//
//  ListViewControllerTests.swift
//  MyWeight
//
//  Created by Bruno Mazzo on 11/6/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Nimble_Snapshots
@testable import HealthService
@testable import MyWeight

class ListViewControllerTests: QuickSpec {

    var viewController: ListViewController!
    var massRepositoryMock: FakeHealthRepository!
    let snapshotService = SnapshotService()

    override func spec() {
        describe("ListViewController") {
            beforeEach {
                self.massRepositoryMock = FakeHealthRepository()
                self.viewController = ListViewController(with: self.massRepositoryMock)
            }

            context("with empty response") {
                it("should have the correct layout") {
                    expect(self.viewController.view).to(self.snapshotService.haveSnapshot())
                }
            }

            context("with items") {
                beforeEach {
                    self.massRepositoryMock.fetchMassResponse = .success([
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
                    _ = self.viewController.view
                    self.viewController.viewWillAppear(true)
                    self.viewController.viewDidAppear(true)
                }

                it("should have the correct layout") {
                    expect(self.viewController.view).to(self.snapshotService.haveSnapshot())
                }
            }
        }
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
