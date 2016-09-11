//
//  UITableViewCell+ReuseIdentifier.swift
//  MyWeight
//
//  Created by Bruno Koga on 22/06/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import UIKit

extension UITableViewCell {
    /**
     - returns: a UINib with the default Nib name (matches the class name).
        If the nib file is not found, this will cause a exception crash.
     */
    static func nib() -> UINib {
        return UINib(nibName: defaultNibName, bundle: nil)
    }
    
    /**
     Default nib name for this class (matches the class name).
     */
    static var defaultNibName: String {
        return String(describing: self)
    }
    
    /**
     Default reuse identifier for this class (matches the class name).
     */
    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableView {
    
    /**
     Register a cell into the tableView.
     Uses the defaultReuseIdentifier if the reuseIdentifier is not provided.
     
     - parameter cellClass: the class to register.
     */
    func registerCellNib(_ cellClass: UITableViewCell.Type, forCellReuseIdentifier reuseIdentifier: String? = nil) {
        self.register(cellClass.nib(), forCellReuseIdentifier: reuseIdentifier ?? cellClass.defaultReuseIdentifier)
    }
    
    /**
     Register a cell into the tableView, using its class.
     Uses the defaultReuseIdentifier if the reuseIdentifier is not provided
     
     - parameter cellClass: the class to register.
     */
    
    func registerCellClass(_ cellClass: UITableViewCell.Type, forCellReuseIdentifier reuseIdentifier: String? = nil) {
        self.register(cellClass.self, forCellReuseIdentifier: reuseIdentifier ?? cellClass.defaultReuseIdentifier)
    }
}
