//
//  FBApi.swift
//  fatherbook-ios
//
//  Created by 张逸 on 16/5/8.
//  Copyright © 2016年 MonzyZhang. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

let kAccount = "account"
let kPassword = "password"

class FBApi {
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
}