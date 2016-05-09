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