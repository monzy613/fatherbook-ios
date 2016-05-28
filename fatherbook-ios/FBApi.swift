//
//  FBApi.swift
//  fatherbook-ios
//
//  Created by Monzy Zhang on 16/5/8.
//  Copyright © 2016年 MonzyZhang. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class FBApi {

    private static let statusDictionary = [
        "000": ("Network error", false),
        "100": ("Get RC Token Success", true),
        "110": ("Get RC Token Failed", false),
        "200": ("Login Success", true),
        "210": ("Wrong password or account", false),

        "300": ("验证码已发送", true),
        "310": ("手机号已被注册", false),
        "320": ("验证码正确", true),
        "330": ("验证码不正确", false),

        "340": ("Register success", true),
        "350": ("Register failed", false),
        "370": ("Account exist", false),

        "400": ("搜索成功", true),
        "410": ("未找到符合条件的用户", false),

        "500": ("关注成功", true),
        "510": ("关注失败", false),
        "520": ("取消关注成功", true),
        "530": ("取消关注失败", false),
        "540": ("获取关注列表成功", true),
        "550": ("获取关注列表失败", false),

        "600": ("timeline 发送成功", true),
        "610": ("timeline 发送失败", false),
        "620": ("timeline 获取成功", true),
        "630": ("timeline 获取失败", false),

        "640": ("点赞成功", true),
        "650": ("点赞失败", false),
        "660": ("取消点赞成功", true),
        "670": ("取消点赞失败", false),
    ]

    class func statusDescription(code: String) -> (String, Bool) {
        let pair = statusDictionary[code]
        if pair == nil {
            return ("no such status code: \(code)", false)
        }
        return (pair!.0, pair!.1)
    }

    class func get(
        withURL url: String,
                parameters: [String: AnyObject]?,
                success: ((JSON) -> (Void))?,
                failure: ((NSError) -> (Void))?) {
        Alamofire.request(.GET, url, parameters: parameters).responseJSON {
            res in
            if let error = res.result.error {
                if let failure = failure {
                    failure(error)
                }
            } else {
                let json = JSON(res.result.value ?? [])
                if let success = success {
                    success(json)
                }
            }
        }
    }

    class func post(
        withURL url: String,
                parameters: [String: AnyObject]?,
                success: ((JSON) -> (Void))?,
                failure: ((NSError) -> (Void))?) {
        print(url)
        Alamofire.request(.POST, url, parameters: parameters).responseJSON {
            res in
            if let error = res.result.error {
                if let failure = failure {
                    failure(error)
                }
            } else {
                let json = JSON(res.result.value ?? [])
                if let success = success {
                    success(json)
                }
            }
        }
    }

    class func fetchUserInfo(success: ((String) -> ())?, failure: ((String) -> ())?) {
        guard let account = FBUserManager.sharedManager().user.account, let password = FBUserManager.sharedManager().user.password else {
            failure?("000")
            return
        }
        FBApi.post(withURL: kFBApiLogin, parameters: [
                kAccount: account,
                kPassword: password
            ], success: { (json) -> (Void) in
            if let status = json["status"].string {
                print(json["userInfo"])
                let outputInfo = FBApi.statusDescription(status).0
                let isSuccess = FBApi.statusDescription(status).1
                if isSuccess {
                    var userInfoJSON = json[kUserInfo]
                    userInfoJSON.appendIfDictionary(kPassword, json: JSON(password))
                    let user = FBUserInfo(json: userInfoJSON)
                    FBPersist.set(value: userInfoJSON.object, forKey: .UserInfo)
                    FBUserManager.sharedManager().user = user
                    success?(outputInfo)
                } else {
                    failure?(outputInfo)
                }
            } else {
                failure?("000")
            }
        }) { (error) -> (Void) in
            failure?("000")
            print("login error: \(error)")
        }
    }
}