//
//  FBAppDelegate.swift
//  fatherbook-ios
//
//  Created by Monzy Zhang on 16/5/8.
//  Copyright © 2016年 MonzyZhang. All rights reserved.
//

import UIKit
import SwiftyJSON


@UIApplicationMain
class FBAppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var loginViewController: FBLoginViewController?
    var rootViewController: FBRootViewController?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        if !checkLogin() {
            loginViewController = FBLoginViewController()
            window = UIWindow(frame: UIScreen.mainScreen().bounds)
            window!.rootViewController = loginViewController!
            window!.backgroundColor = UIColor.whiteColor()
            window?.makeKeyAndVisible()
        } else {
            rootViewController = FBRootViewController()
            let navigationController = UINavigationController(rootViewController: FBRootViewController())
            window = UIWindow(frame: UIScreen.mainScreen().bounds)
            window!.rootViewController = navigationController
            window!.backgroundColor = UIColor.clearColor()
            window?.makeKeyAndVisible()
        }
        return true
    }

    func checkLogin() -> Bool {
        if let userInfoObject = FBPersist.getValue(forKey: .UserInfo), let rcToken = FBPersist.getValue(forKey: .RCToken) as? String {
            let userInfoJSON = JSON(userInfoObject)
            FBUserManager.sharedManager().user = FBUserInfo(json: userInfoJSON)
            FBRCChatManager.sharedManager().rcToken = rcToken
            return true
        }
        return false
    }
}