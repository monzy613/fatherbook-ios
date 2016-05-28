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

var kFBRCToken: String {
    return "\(kFBBaseURL)/app.rongcloud.token"
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

var kFBApiTimeline: String {
    return "\(kFBBaseURL)/app.timeline.post"
}

var kFBApiGetTimeline: String {
    return "\(kFBBaseURL)/app.timeline.get"
}

let kAccount = "account"
let kSearchString = "searchString"
let kPassword = "password"
let kUserInfo = "userInfo"
let kTargetID = "targetID"
let kFollowInfos = "follow_infos"
let kTimelines = "timelines"
let kImages = "images"
let kText = "text"
let kID = "_id"
let kRepostCount = "repostCount"
let kIsRepost = "isRepost"
let kRepostTimeline = "repostTimeline"
let kLiked = "liked"
let kComments = "comments"
let kIndex = "index"
let kURL = "url"