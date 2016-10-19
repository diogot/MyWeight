//
//  ClearButton.swift
//  MyWeight
//
//  Created by Diogo on 19/10/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import UIKit

class ClearButton: UIButton {

    override public required init(frame: CGRect)
    {
        self.style = Style()
        self.title = ""

        super.init(frame: frame)

        layer.borderColor = style.textLightColor.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = style.grid / 2
        layer.masksToBounds = true
        let padding = style.grid * 2
        contentEdgeInsets = UIEdgeInsetsMake(padding, padding, padding, padding)
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let style: StyleProvider

    public var title: String {
        didSet {
            let attributedString = NSAttributedString(string: title,
                                                      font: style.callout,
                                                      color: style.textLightColor)

            setAttributedTitle(attributedString,
                               for: .normal)
        }
    }

}
