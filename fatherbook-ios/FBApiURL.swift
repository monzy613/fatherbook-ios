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

var kFBApiPostTimeline: String {
    return "\(kFBBaseURL)/app.timeline.post"
}

var kFBApiGetTimeline: String {
    return "\(kFBBaseURL)/app.timeline.get"
}

var kFBApiChangeAvatar: String {
    return "\(kFBBaseURL)/app.changeavatar"
}

var kFBApiGetTimelineByFollowing: String {
    return "\(kFBBaseURL)/app.timeline.getByFollowing"
}

var kFBApiTimelineLike: String {
    return "\(kFBBaseURL)/app.timeline.like"
}

var kFBApiTimelineUnlike: String {
    return "\(kFBBaseURL)/app.timeline.unlike"
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
let kTimelineID = "timelineID"
let kComments = "comments"

let kIndex = "index"
let kURL = "url"
let kWidth = "width"
let kHeight = "height"

let kToken = "token"
let kTokens = "tokens"
let kFilename = "filename"
let kConfig = "config"

let kMaxID = "maxID"
let kCount = "count"