//
//  GradientView.swift
//  MyWeight
//
//  Created by Bruno Mazzo on 11/6/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import Foundation
import UIKit

class GradientView: UIView {
    
    let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configure()
    }
    
    func configure() {
        self.layer.addSublayer(self.gradientLayer)
        self.gradientLayer.backgroundColor = UIColor.clear.cgColor
    }
    
    open var colors: [UIColor]? {
        get {
            if let colors = self.gradientLayer.colors {
                return colors.map { UIColor(cgColor: $0 as! CGColor) }
            }
            
            return nil
        }
        set {
            self.gradientLayer.colors = (newValue ?? []).map { $0.cgColor }
        }
    }
    
    open var locations: [NSNumber]? {
        get {
            return self.gradientLayer.locations
        }
        set {
            self.gradientLayer.locations = newValue
        }
    }
    
    open var startPoint: CGPoint {
        get {
            return self.gradientLayer.startPoint
        }
        set {
            self.gradientLayer.startPoint = newValue
        }
    }
    
    open var endPoint: CGPoint {
        get {
            return self.gradientLayer.endPoint
        }
        set {
            self.gradientLayer.endPoint = newValue
        }
    }
    
    open var type: String {
        get {
            return self.gradientLayer.type
        }
        set {
            self.gradientLayer.type = newValue
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.gradientLayer.frame = self.bounds
    }
}
