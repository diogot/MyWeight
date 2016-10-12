//
//  Style.swift
//  MyWeight
//
//  Created by Diogo on 09/10/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import UIKit

public protocol StyleProvider {

    var backgroundColor: UIColor { get }

    var textColor: UIColor { get }
    var textLightColor: UIColor { get }
    var textInTintColor: UIColor { get }

    var tintColor: UIColor { get }

    var title1: UIFont { get }
    var title2: UIFont { get }
    var title3: UIFont { get }
    var body: UIFont { get }
    var callout: UIFont { get }
    var subhead: UIFont { get }
    var footnote: UIFont { get }

    var grid: CGFloat { get }

}

public struct Style: StyleProvider {

    public let backgroundColor: UIColor = Style.white

    public let textColor: UIColor = Style.black
    public let textLightColor: UIColor = Style.gray
    public let textInTintColor: UIColor = Style.lightGray

    public let tintColor: UIColor = Style.teal

    public let title1 = UIFont.systemFont(ofSize: 42, weight: UIFontWeightHeavy)
    public let title2 = UIFont.systemFont(ofSize: 28, weight: UIFontWeightSemibold)
    public let title3 = UIFont.systemFont(ofSize: 22, weight: UIFontWeightBold)
    public let body = UIFont.systemFont(ofSize: 20, weight: UIFontWeightMedium)
    public let callout = UIFont.systemFont(ofSize: 18, weight: UIFontWeightMedium)
    public let subhead = UIFont.systemFont(ofSize: 15, weight: UIFontWeightMedium)
    public let footnote = UIFont.systemFont(ofSize: 13, weight: UIFontWeightMedium)

    public let grid: CGFloat = 8

    static let teal = UIColor(red: 81/255, green: 203/255, blue: 212/255, alpha: 1)
    static let black = UIColor(red: 67/255, green: 70/255, blue: 75/255, alpha: 1)
    static let gray = UIColor(red: 168/255, green: 174/255, blue: 186/255, alpha: 1)
    static let lightGray = UIColor(red: 241/255, green: 243/255, blue: 246/255, alpha: 1)
    static let white = UIColor(white: 1, alpha: 1)

}
