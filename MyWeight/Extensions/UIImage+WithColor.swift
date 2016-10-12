//
//  UIImage+WithColor.swift
//  MyWeight
//
//  Created by Diogo on 11/10/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import UIKit

extension UIImage {

    static func image(with color: UIColor) -> UIImage
    {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        let renderer = UIGraphicsImageRenderer(bounds: rect)

        let image = renderer.image { _ in
            color.setFill()
            UIRectFill(rect)
        }

        return image
    }
}
