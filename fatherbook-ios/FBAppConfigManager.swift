//
//  FBAppConfigManager.swift
//  fatherbook-ios
//
//  Created by Monzy Zhang on 6/1/16.
//  Copyright © 2016 MonzyZhang. All rights reserved.
//
import SwiftyJSON

private let kRCAppkey = "rcAppkey"
private let kRCAppSecret = "rcAppSecret"
private let kQNBucketDomain = "qnBucketDomain"

class FBAppConfigManager {
    private static var _sharedManager: FBAppConfigManager?

    var kRongCloudAppKey: String!
    var kRongCloudAppSecret: String!
    var kQiniuBucketDomain: String! = "http://o7b20it1b.bkt.clouddn.com"

    func avatarURL(withName name: String) -> String {
        return "\(self.kQiniuBucketDomain!)/\(name)?_=\(Int(NSDate().timeIntervalSince1970) + 200)"
    }

    init(withJSON json: JSON) {
        kRongCloudAppKey = json[kRCAppkey].string ?? ""
        kRongCloudAppSecret = json[kRCAppSecret].string ?? ""
        kQiniuBucketDomain = json[kQNBucketDomain].string ?? ""
    }

    private init() {
        kRongCloudAppKey = ""
        kRongCloudAppSecret = ""
        kQiniuBucketDomain = ""
    }

    class func initSharedManager(withJSON json: JSON) {
        _sharedManager = FBAppConfigManager(withJSON: json)
    }

    class func sharedManager() -> FBAppConfigManager {
        if _sharedManager == nil {
            _sharedManager = FBAppConfigManager()
        }
        return _sharedManager!
    }
}

/*
 "config": {
 "rcAppkey": config.rcAppkey,
 "rcAppSecret": config.rcAppSecret,
 "qnBucketDomain": config.qnBucketDomain
 }
 */