import Quick
import Nimble
import Nimble_Snapshots

@testable import MyWeight

class AddViewControllerTests: QuickSpec {
    
    var viewController: AddViewController!
    let snapshotService = SnapshotService()
    var window: UIWindow!
    
    override func spec() {
        describe("AddViewController Layout") {
            beforeEach {
                self.viewController = AddViewController(with: MassRepositoryMock(), startMass: Mass())

                //For some misterios (apple bug) reason, setDate not work if you don't add the view to a window.
                let frame = UIScreen.main.bounds
                let window = UIWindow(frame: frame)
                window.rootViewController = self.viewController
                window.makeKeyAndVisible()
                self.window = window
                self.viewController.view.frame = frame
            }
            
            it("should have the correct portrait layout on all Sizes") {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                let testDate = dateFormatter.date(from: "10/10/2016")!

                self.viewController.theView.datePicker.setDate(testDate, animated: false)
                expect(self.viewController.view).to(self.snapshotService.haveSnapshot(usesDrawRect: true))
            }
        }
    }
}
