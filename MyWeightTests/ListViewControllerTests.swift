//
//  ListViewControllerTests.swift
//  MyWeight
//
//  Created by Bruno Mazzo on 11/6/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import Quick
import Nimble
import Nimble_Snapshots

@testable import MyWeight

class ListViewControllerTests: QuickSpec {
    
    var viewController: ListViewController!
    var massRepositoryMock: MassRepositoryMock!
    let snapshotService = SnapshotService()
    
    override func spec() {
        describe("ListViewController") {
            beforeEach {
                self.massRepositoryMock = MassRepositoryMock()
                self.viewController = ListViewController(with: self.massRepositoryMock)
                self.viewController.view.frame = UIScreen.main.bounds
            }
            
            context("with empty response") {
                it("should have the correct layout") {
                    expect(self.viewController.view).to(self.snapshotService.haveSnapshot())
                }
            }
            
            context("with items") {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"                
                beforeEach {
                    self.massRepositoryMock.fetchResponse = [
                        Mass(value: Measurement(value: 60, unit: .kilograms), date: dateFormatter.date(from: "10/10/2016 10:10")!),
                        Mass(value: Measurement(value: 62, unit: .kilograms), date: dateFormatter.date(from: "08/10/2016 9:10")!),
                        Mass(value: Measurement(value: 64, unit: .kilograms), date: dateFormatter.date(from: "06/10/2016 11:30")!),
                        Mass(value: Measurement(value: 66, unit: .kilograms), date: dateFormatter.date(from: "02/10/2016 12:00")!),
                        Mass(value: Measurement(value: 68, unit: .kilograms), date: dateFormatter.date(from: "30/09/2016 14:44")!),
                        Mass(value: Measurement(value: 70, unit: .kilograms), date: dateFormatter.date(from: "28/09/2016 16:31")!),
                        Mass(value: Measurement(value: 72, unit: .kilograms), date: dateFormatter.date(from: "26/09/2016 18:20")!),
                        Mass(value: Measurement(value: 74, unit: .kilograms), date: dateFormatter.date(from: "24/09/2016 20:10")!),
                        Mass(value: Measurement(value: 76, unit: .kilograms), date: dateFormatter.date(from: "22/09/2016 22:44")!),
                    ]
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
