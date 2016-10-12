//
//  NSAttributedString+FontColor.swift
//  MyWeight
//
//  Created by Diogo on 11/10/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import UIKit

extension NSAttributedString {

    convenience init(string: String, font: UIFont?, color: UIColor?)
    {
        var attributes = [String: Any]()

        if let font = font {
            attributes[NSFontAttributeName] = font
        }

        if let color = color {
            attributes[NSForegroundColorAttributeName] = color
        }

        self.init(string: string, attributes: attributes)
    }
    
}
