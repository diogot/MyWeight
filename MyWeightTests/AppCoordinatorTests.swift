import Nimble
import Nimble_Snapshots
import UIKit
import XCTest

@testable import MyWeight

class AppCoordinatorTests: XCTestCase {
    
    var appCoordinator: AppCoordinator!
    var navigationController: NotAnimationNavigationController!
    var window: UIWindow!
    
    override func setUp() {
        super.setUp()
        navigationController = NotAnimationNavigationController()
        appCoordinator = AppCoordinator(with: navigationController)

        let windowSize = CGRect(x: 0, y: 0, width: 320, height: 640)
        let window = UIWindow(frame: windowSize)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
    }

    func testShouldPresetAddViewControllerOnStartAdd() {
        appCoordinator.startAdd(last: nil)
        expect(self.navigationController.presentedViewController).to(beAnInstanceOf(AddViewController.self))
    }

    func testShouldPresentAuthorizationRequestViewControllerOnStartAuthorizationRequest() {
        appCoordinator.startAuthorizationRequest()
        expect(self.navigationController.presentedViewController).to(beAnInstanceOf(AuthorizationRequestViewController.self))

    }

    func testShouldPresentAccessDeniedViewControllerOnStartAuthorizationDenied() {
        appCoordinator.startAuthorizationDenied()
        expect(self.navigationController.presentedViewController).to(beAnInstanceOf(AccessDeniedViewController.self))

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
