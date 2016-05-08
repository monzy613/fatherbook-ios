//
//  FBApiURL.swift
//  fatherbook-ios
//
//  Created by 张逸 on 16/5/8.
//  Copyright © 2016年 MonzyZhang. All rights reserved.
//

var kFBIP = "192.168.1.102"
var kFBPort = "3000"

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