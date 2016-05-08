//
//  FBConsts.swift
//  fatherbook-ios
//
//  Created by 张逸 on 16/5/8.
//  Copyright © 2016年 MonzyZhang. All rights reserved.
//
import Foundation

class FBConsts {
    static let sharedInstance: FBConsts = FBConsts()

    let kBaseURL: String

    private init() {
        let configPath = NSBundle.mainBundle().pathForResource("config", ofType: "plist")
        let dictionary = NSDictionary(contentsOfFile: configPath!) ?? ["kBaseURL": "http://192.168.1.102:3000"]
        kBaseURL = dictionary["kBaseURL"]?.stringValue ?? "http://192.168.1.102:3000"
    }
}