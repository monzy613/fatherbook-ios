//
//  FBUserManager.swift
//  fatherbook-ios
//
//  Created by Monzy Zhang on 5/12/16.
//  Copyright © 2016 MonzyZhang. All rights reserved.
//

import Foundation

class FBUserManager: NSObject, RCIMUserInfoDataSource {
    var user: FBUserInfo!
    var rcInitSuccess: Bool = false

    private static var sharedInstance: FBUserManager?

    class func sharedManager() -> FBUserManager {
        if sharedInstance == nil {
            sharedInstance = FBUserManager()
        }
        return sharedInstance!
    }

    private override init() {
        super.init()
        RCIM.sharedRCIM().userInfoDataSource = self
    }

    // MARK: RCIMUserInfoDataSource
    func getUserInfoWithUserId(userId: String!, completion: ((RCUserInfo!) -> Void)!) {
        let userInfo = RCUserInfo(userId: userId, name: "", portrait: "")
        userInfo.name = user.nicknameWithAccount(userId) ?? userId
        userInfo.portraitUri = user.avatarURLWithAccount(userId)
        completion(userInfo)
    }
}