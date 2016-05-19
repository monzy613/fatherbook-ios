//
//  FBPersist.swift
//  fatherbook-ios
//
//  Created by Monzy Zhang on 5/19/16.
//  Copyright © 2016 MonzyZhang. All rights reserved.
//

import Foundation

enum FBPersistKey: String {
    case UserInfo = "fb_userinfo"
    case RCToken = "fb_rc_token"
}

class FBPersist {
    class func set(value value: AnyObject?, forKey key: FBPersistKey) {
        NSUserDefaults.standardUserDefaults().setObject(value, forKey: key.rawValue)
    }

    class func getValue(forKey key: FBPersistKey) -> AnyObject? {
        return NSUserDefaults.standardUserDefaults().valueForKey(key.rawValue)
    }
}