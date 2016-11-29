
import Quick
import Nimble
import Nimble_Snapshots

@testable import MyWeight

class AddViewControllerTests: QuickSpec {
    
    var viewController: AddViewController!
    let snapshoService = SnapshotService()
    
    var window: UIWindow!
    
    override func spec() {
        describe("AddViewController Layout") {
            beforeEach {
                self.window = nil
                self.viewController = AddViewController(with: MassService(), startMass: Mass())
            }
            
            it("should have the correct portrait layout on all Sizes") {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                let testDate = dateFormatter.date(from: "10/10/2016")!
                
                expect(self.viewController.view) == self.snapshoService.snapshot("AddViewController - With Items", sizes: self.snapshoService.iPhonePortraitSizes, usesDrawRect: true, customResize: { view, size in
                    //For some misterios (apple bug) reason, setDate not work if you don't add the view to a window.
                    
                    let newRect = CGRect(origin: CGPoint.zero, size: size)
                    let window = UIWindow(frame: newRect)
                    window.rootViewController = self.viewController
                    window.makeKeyAndVisible()
                    self.window = window
                    
                    self.viewController.view.bounds = newRect
                    
                    self.viewController.theView.datePicker.setDate(testDate, animated: false)
                })
            }
        }
    }
}
