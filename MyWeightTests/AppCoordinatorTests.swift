
import Quick
import Nimble
import Nimble_Snapshots
import UIKit

@testable import MyWeight

class AppCoordinatorTests: QuickSpec {
    
    var appCoordinator: AppCoordinator!
    var navigationController: NotAnimationNavigationController!
    var window: UIWindow!
    

    override func spec() {
        describe("appCoordinator") {
            beforeEach {
                self.navigationController = NotAnimationNavigationController()
                self.appCoordinator = AppCoordinator(with: self.navigationController)
                
                let windowSize = CGRect(x: 0, y: 0, width: 320, height: 640)
                let window = UIWindow(frame: windowSize)
                window.rootViewController = self.navigationController
                window.makeKeyAndVisible()
                self.window = window
            }
            
            context("behavior") {
                it("should present a AddViewController on startAdd call") {
                    self.appCoordinator.startAdd(last: nil)
                    
                    expect(self.navigationController.presentedViewController).to(beAnInstanceOf(AddViewController.self))
                }
                
                
                it("should present a AuthorizationRequestViewController on startAuthorizationRequest call") {
                    self.appCoordinator.startAuthorizationRequest()
                    
                    expect(self.navigationController.presentedViewController).to(beAnInstanceOf(AuthorizationRequestViewController.self))
                }
                
                it("should present a AccessDeniedViewController on startAuthorizationDenied call") {
                    self.appCoordinator.startAuthorizationDenied()
                    
                    expect(self.navigationController.presentedViewController).to(beAnInstanceOf(AccessDeniedViewController.self))
                }
                
            }
        }
    }
}

class NotAnimationNavigationController: UINavigationController {
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: false)
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        return super.popViewController(animated: false)
    }
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        super.present(viewControllerToPresent, animated: false, completion: completion)
    }
    
}
