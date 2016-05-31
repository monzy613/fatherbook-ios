//
//  FBTimeline.swift
//  fatherbook-ios
//
//  Created by Monzy Zhang on 5/28/16.
//  Copyright © 2016 MonzyZhang. All rights reserved.
//

import SwiftyJSON

class FBTimelineImage {
    var index = 0
    var imageURL: NSURL?
    var imageSize = CGSizeZero

    init(json: JSON) {
        index = Int(json[kIndex].string ?? "0") ?? 0
        imageURL = NSURL(string: json[kURL].stringValue)
        let width = CGFloat(json[kWidth].double ?? 0.0)
        let height = CGFloat(json[kHeight].double ?? 0.0)
        self.imageSize = CGSizeMake(width, height)
    }
}

class FBTimeline: NSObject {
    var user: FBUserInfo?
    var id: Int = -1
    var timeStamp: String?
    var repostCount: Int = 0
    var isRepost = false
    var repostTimeline: FBTimeline?
    var liked = [FBUserInfo]()
    var comments = [FBUserInfo]()
    var text: String?
    var images = [FBTimelineImage]()

    init(json: JSON) {
        super.init()
        user = FBUserInfo(json: json[kUserInfo])
        id = json[kID].int ?? -1
        text = json[kText].stringValue
        repostCount = json[kRepostCount].intValue
        isRepost = json[kIsRepost].boolValue
        if let likedJSONs = json[kLiked].array {
            for userInfo in likedJSONs {
                liked.append(FBUserInfo(json: userInfo))
            }
        }
        if let imagesJSONs = json[kImages].array {
            for imageJSON in imagesJSONs {
                images.append(FBTimelineImage(json: imageJSON))
            }
        }
        if isRepost {
            repostTimeline = FBTimeline(json: json[kRepostTimeline])
        }
    }
}