//
//  TintButton.swift
//  MyWeight
//
//  Created by Diogo on 12/10/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import UIKit

public class TintButton: UIButton {

    override public required init(frame: CGRect)
    {
        self.style = Style()
        self.title = ""

        super.init(frame: frame)

        setBackgroundImage(UIImage.image(with: style.tintColor),
                           for: .normal)
        layer.cornerRadius = style.grid / 2
        layer.masksToBounds = true
        let padding = style.grid * 2
        contentEdgeInsets = UIEdgeInsets.init(top: padding, left: padding,
                                              bottom: padding, right: padding)
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let style: StyleProvider

    public var title: String {
        didSet {
            let attributedString = NSAttributedString(string: title,
                                                      font: style.title3,
                                                      color: style.textInTintColor)

            setAttributedTitle(attributedString,
                               for: .normal)
        }
    }

}
