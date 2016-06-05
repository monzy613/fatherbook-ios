//
//  FBQNManager.swift
//  fatherbook-ios
//
//  Created by Monzy Zhang on 6/5/16.
//  Copyright © 2016 MonzyZhang. All rights reserved.
//

import Qiniu

class FBQNManager {
    private static var sharedInstance: FBQNManager?

    // id: (sum: completeAmount)
    var timelineImageQueue: [Int: (Int, Int)] = [:]

    class func sharedManager() -> FBQNManager {
        if sharedInstance == nil {
            sharedInstance = FBQNManager()
        }
        return sharedInstance!
    }
}