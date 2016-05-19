//
//  FBTheme.swift
//  fatherbook-ios
//
//  Created by Monzy Zhang on 5/12/16.
//  Copyright © 2016 MonzyZhang. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift


extension UIFont {
    class func fb_defaultFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "Avenir-Light", size: size) ?? UIFont.systemFontOfSize(size)
    }
}

extension UIColor {
    class func fb_lightColor() -> UIColor {
        return UIColor(rgba: "#BBC1CC")
    }

    class func fb_darkColor() -> UIColor {
        return UIColor(rgba: "#151E33")
    }

    class func fb_darkRedColor() -> UIColor {
        return UIColor(rgba: "#B60000")
    }

    class func fb_grayColor() -> UIColor {
        return UIColor(rgba: "#939AA7")
    }

    class func fb_lightGrayColor() -> UIColor {
        return UIColor(rgba: "#DCDCDC")
    }
}

extension UIView {
    convenience init(bgColor: UIColor) {
        self.init()
        backgroundColor = bgColor
    }
}

class FBLayout {
    private let cellHeightDictionary: [String: CGFloat] = [
        NSStringFromClass(FBUserTableViewCell.self): 87.0
        ]

    class func heightForCellWithReuseIdentifier(identifier: String) -> CGFloat {
        switch identifier {
        case NSStringFromClass(FBUserTableViewCell.self):
            return CGRectGetWidth(UIScreen.mainScreen().bounds) * 0.232
        case NSStringFromClass(FBAlbumPreviewTableViewCell.self):
            return CGRectGetWidth(UIScreen.mainScreen().bounds) * 0.208
        default:
            return 87.0
        }
    }
}