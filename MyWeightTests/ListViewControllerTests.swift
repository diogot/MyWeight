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
    let snapshoService = SnapshotService()
    
    override func spec() {
        describe("ListViewController Layout") {
            beforeEach {
                self.massRepositoryMock = MassRepositoryMock()
                self.viewController = ListViewController(with: self.massRepositoryMock)
            }
            
            context("On empty response") {
                it("should have the correct portrait layout on all Sizes") {
                    expect(self.viewController.view) == self.snapshoService.snapshot("ListViewController - Empty", sizes: self.snapshoService.iPhonePortraitSizes)
                }
            }
            
            context("On items") {
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
                
                beforeEach {
                    
                    
                    self.massRepositoryMock.fetchResponse = [
                        Mass(value: Measurement(value: 60, unit: UnitMass.kilograms), date: dateFormatter.date(from: "10/10/2016 10:10")!),
                        Mass(value: Measurement(value: 62, unit: UnitMass.kilograms), date: dateFormatter.date(from: "08/10/2016 9:10")!),
                        Mass(value: Measurement(value: 64, unit: UnitMass.kilograms), date: dateFormatter.date(from: "06/10/2016 11:30")!),
                        Mass(value: Measurement(value: 66, unit: UnitMass.kilograms), date: dateFormatter.date(from: "02/10/2016 12:00")!),
                        Mass(value: Measurement(value: 68, unit: UnitMass.kilograms), date: dateFormatter.date(from: "30/09/2016 14:44")!),
                        Mass(value: Measurement(value: 70, unit: UnitMass.kilograms), date: dateFormatter.date(from: "28/09/2016 16:31")!),
                        Mass(value: Measurement(value: 72, unit: UnitMass.kilograms), date: dateFormatter.date(from: "26/09/2016 18:20")!),
                        Mass(value: Measurement(value: 74, unit: UnitMass.kilograms), date: dateFormatter.date(from: "24/09/2016 20:10")!),
                        Mass(value: Measurement(value: 76, unit: UnitMass.kilograms), date: dateFormatter.date(from: "22/09/2016 22:44")!),
                    ]
                    _ = self.viewController.view
                    self.viewController.viewWillAppear(true)
                    self.viewController.viewDidAppear(true)
                    
                }
                
                it("should have the correct portrait layout on all Sizes") {
                    expect(self.viewController.view) == self.snapshoService.snapshot("ListViewController - With Items", sizes: self.snapshoService.iPhonePortraitSizes)
                }
            }
        }
    }
}

class MassRepositoryMock: MassRepository {
    var fetchResponse: [Mass]?
    
    func fetch(_ completion: @escaping (_ results: [Mass]) -> Void) {
        completion(self.fetchResponse ?? [])
    }
}
