import Quick
import Nimble
import Nimble_Snapshots
import UIKit

@testable import MyWeight

class AddViewControllerTests: QuickSpec {

    var viewController: AddViewController!
    let snapshotService = SnapshotService()
    let timezone = TimeZone(secondsFromGMT: 0)
    var testDate: Date!

    override func spec() {
        describe("AddViewController Layout") {
            beforeEach {
                self.testDate = Date(timeIntervalSinceReferenceDate: 12345)
                self.viewController = AddViewController(with: FakeHealthRepository(), startMass: .init(), now: self.testDate)
            }

            it("should have the correct portrait layout on all Sizes") {
                self.viewController.theView.datePicker.timeZone = self.timezone
                expect(self.viewController.view).to(self.snapshotService.haveSnapshot(usesDrawRect: true, tolerance: 0.0001))
            }
        }
    }
}
