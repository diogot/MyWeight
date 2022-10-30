import Nimble
import Nimble_Snapshots
import UIKit
import XCTest

@testable import MyWeight

class AddViewControllerTests: XCTestCase {

    var viewController: AddViewController!
    let snapshotService = SnapshotService()
    let timezone = TimeZone(secondsFromGMT: 0)
    var testDate: Date!

    override func setUp() {
        super.setUp()
        testDate = Date(timeIntervalSinceReferenceDate: 12345)
        viewController = AddViewController(with: FakeHealthRepository(), startMass: .init(), now: testDate)
        viewController.theView.datePicker.timeZone = timezone
    }

    func testSnapshot() {
        expect(self.viewController.view).to(snapshotService.haveSnapshot(usesDrawRect: true, tolerance: 0.0001))
    }
}
