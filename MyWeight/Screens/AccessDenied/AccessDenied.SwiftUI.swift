//
//  AccessDenied.SwiftUI.swift
//  MyWeight
//
//  Created by Bruno Mazzo on 3/9/2022.
//  Copyright © 2022 Diogo Tridapalli. All rights reserved.
//

import Foundation
import SwiftUI

struct AccessDeniedViewControllerFromUIKit: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return AccessDeniedViewController()
    }
}

struct AccessDeniedViewController_Preview: PreviewProvider {
    static var previews: some View {
        AccessDeniedViewControllerFromUIKit()
        AccessDeniedViewFromSwiftUI(delegate: AccessDeniedIsPresentingDelegate())
    }
}

public struct AccessDeniedViewFromSwiftUI: View {
    
    var delegate: AccessDeniedIsPresentingDelegate
    var style = Style()
    
    var items = [(#imageLiteral(resourceName: "ic-cog"), Localization.accessDeniedSettings),
                               (#imageLiteral(resourceName: "ic-permission"), Localization.accessDeniedPrivacy),
                               (#imageLiteral(resourceName: "ic-health"), Localization.accessDeniedHealth),
                               (#imageLiteral(resourceName: "ic-myweight"), Localization.accessDeniedMyWeight)]
    
    public var body: some View {
        VStack(alignment: .leading) {
            Group {
                Text("Permissions")
                    .foregroundColor(Color(style.textColor))
                    .font(Font(style.title1))
                    .padding(.top, style.grid * 3)
                
                Spacer().frame(height: style.grid * 2)
                
                Group {
                    // iOS 14 doesn't supports Swift Attributed strings
                    Text("MyWeight needs access to") + Text(" **Health** ").foregroundColor(Color(style.textColor)) + Text("in order to store your entries")
                }
                    .foregroundColor(Color(style.textLightColor))
                    .font(Font(style.body))
                    
                
                ForEach(items, id: \.1) { item in
                    HStack {
                        Image(uiImage: item.0)
                        Spacer().frame( width: style.grid * 2)
                        Text(item.1)
                            .foregroundColor(Color(style.textColor))
                            .font(Font(style.subhead))
                    }
                    .padding( .vertical, style.grid)
                }
            }.padding(.horizontal, style.grid * 3)
            Spacer()
            Button("Got it") {
                delegate.didEnd()
            }
            .buttonStyle(BlueButton())
            .padding(.bottom, style.grid * 2)
        }
    }
}

class AccessDeniedIsPresentingDelegate {
    var delegate: AccessDeniedViewControllerDelegate?
    var hostingViewController: UIViewController?
    
    func didEnd() {
        if let hostingViewController = hostingViewController {
            self.delegate?.didFinish(on: hostingViewController)
        }
    }
}

public class AccessDeniedViewControllerSwiftUI: UIHostingController<AccessDeniedViewFromSwiftUI> {
    
    public var delegate: AccessDeniedViewControllerDelegate? {
        didSet {
            isPresentingDelegate.delegate = delegate
        }
    }
    
    private var isPresentingDelegate = AccessDeniedIsPresentingDelegate()

    public required init()
    {
        super.init(rootView: AccessDeniedViewFromSwiftUI(delegate: self.isPresentingDelegate))
        
        isPresentingDelegate.hostingViewController = self
        
    }
    
    public override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = Style().backgroundColor
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
