//
//  FBConsts.swift
//  fatherbook-ios
//
//  Created by Monzy Zhang on 16/5/8.
//  Copyright © 2016年 MonzyZhang. All rights reserved.
//
import Foundation

private struct FBConfigKey {
    static let kRongCloudAppKey = "kRongCloudAppKey"
    static let kRongCloudAppSecret = "kRongCloudAppSecret"
    static let kBaseURL = "kBaseURL"
}

class FBConsts {
    static var sharedInstance: FBConsts = FBConsts()

    let kBaseURL: String
    let kRongCloudAppKey: String
    let kRongCloudAppSecret: String

    private init() {
        let configPath = NSBundle.mainBundle().pathForResource("config", ofType: "plist")
        let dictionary = NSDictionary(contentsOfFile: configPath!) ?? ["kBaseURL": "http://192.168.1.103:3000"]
        kBaseURL = (dictionary[FBConfigKey.kBaseURL]! as? String) ?? "http://192.168.1.101:3000"
        kRongCloudAppKey = (dictionary[FBConfigKey.kRongCloudAppKey]! as? String) ?? ""
        kRongCloudAppSecret = (dictionary[FBConfigKey.kRongCloudAppSecret]! as? String) ?? ""
    }
}