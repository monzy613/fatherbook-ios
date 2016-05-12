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
        return UIColor(rgba: "#010B21")
    }
}