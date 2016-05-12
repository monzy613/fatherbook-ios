//
//  FBViewGenerator.swift
//  fatherbook-ios
//
//  Created by Monzy Zhang on 16/5/9.
//  Copyright © 2016年 MonzyZhang. All rights reserved.
//

import UIKit


class FBViewGenerator {
    class func fbTextField(placeHolder placeHolder: String = "", secureTextEntry: Bool = false, font: UIFont = UIFont.fb_defaultFontOfSize(14)) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeHolder
        textField.font = font
        textField.secureTextEntry = secureTextEntry
        return textField
    }
}