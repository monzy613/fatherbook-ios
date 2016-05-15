//
//  FBApiURL.swift
//  fatherbook-ios
//
//  Created by Monzy Zhang on 16/5/8.
//  Copyright © 2016年 MonzyZhang. All rights reserved.
//

var kFBBaseURL: String {
    return FBConsts.sharedInstance.kBaseURL
}


/**
 * /app.register
 */
var kFBApiRegister: String {
    return "\(kFBBaseURL)/app.register"
}

/**
 * /app.login
 */
var kFBApiLogin: String {
    return "\(kFBBaseURL)/app.login"
}

var kFBApiSearchAccount: String {
    return "\(kFBBaseURL)/app.search.account"
}

var kFBApiFollow: String {
    return "\(kFBBaseURL)/app.friend.follow"
}

var kFBApiUnFollow: String {
    return "\(kFBBaseURL)/app.friend.unfollow"
}

var kFBApiFollowing: String {
    return "\(kFBBaseURL)/app.friend.following"
}

let kAccount = "account"
let kSearchString = "searchString"
let kPassword = "password"
let kUserInfo = "userInfo"
let kTargetID = "targetID"
let kFollowInfos = "follow_infos"