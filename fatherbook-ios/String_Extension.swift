//
//  String_Extension.swift
//  fatherbook-ios
//
//  Created by Monzy Zhang on 5/16/16.
//  Copyright © 2016 MonzyZhang. All rights reserved.
//

import Foundation


extension String {
    func transformToPinyin () -> String {
        let mutableString = NSMutableString(string: self)
        CFStringTransform(mutableString as CFMutableStringRef, nil, kCFStringTransformToLatin, false)
        CFStringTransform(mutableString as CFMutableStringRef, nil, kCFStringTransformStripDiacritics, false)
        let pinyinStr = mutableString.stringByReplacingOccurrencesOfString(" ", withString: "")
        return pinyinStr
    }

    func firstChar() -> String {
        for char in self.characters {
            return String(char)
        }
        return ""
    }

    func firstLowerCaseChar() -> String {
        for char in self.characters {
            return String(char).lowercaseString
        }
        return ""
    }
}