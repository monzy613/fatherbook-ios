//
//  FBUserManager.swift
//  fatherbook-ios
//
//  Created by Monzy Zhang on 5/12/16.
//  Copyright © 2016 MonzyZhang. All rights reserved.
//

import Foundation

class FBUserManager {
    var user: FBUserInfo!
    var rcInitSuccess: Bool = false

    private static var sharedInstance: FBUserManager?

    class func sharedManager() -> FBUserManager {
        if sharedInstance == nil {
            sharedInstance = FBUserManager()
        }
        return sharedInstance!
    }

    private init() {
    }
}