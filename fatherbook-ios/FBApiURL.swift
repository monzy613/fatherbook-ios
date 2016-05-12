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

var kFBApiApply: String {
    return "\(kFBBaseURL)/app.friend.apply"
}

let kAccount = "account"
let kPassword = "password"
let kUserInfo = "userInfo"
let kApplier = "applier"
let kApplied = "applied"
let kApplyDate = "applyDate"
let kApplyMessage = "applyMessage"