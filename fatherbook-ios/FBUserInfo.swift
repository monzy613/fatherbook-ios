//
//  FBUserInfo.swift
//  fatherbook-ios
//
//  Created by Monzy Zhang on 16/5/9.
//  Copyright © 2016年 MonzyZhang. All rights reserved.
//

import UIKit
import SwiftyJSON

class FBUserInfo: NSObject, NSCoding {
    static var sharedUser: FBUserInfo!
    
    var account: String?
    var phone: String?
    var email: String?
    var nickname: String?
    var rcToken: String?

    init(json: JSON) {
        super.init()
        account = json["account"].string
        phone = json["phone"].string
        email = json["email"].string
        nickname = json["nickname"].string
        rcToken = json["rcToken"].string
        FBUserInfo.sharedUser = self
    }

    required init?(coder aDecoder: NSCoder) {
        super.init()
        account = aDecoder.decodeObjectForKey("account") as? String
        phone = aDecoder.decodeObjectForKey("phone") as? String
        email = aDecoder.decodeObjectForKey("email") as? String
        nickname = aDecoder.decodeObjectForKey("nickname") as? String
        FBUserInfo.sharedUser = self
    }

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(account, forKey: "account")
        aCoder.encodeObject(phone, forKey: "phone")
        aCoder.encodeObject(email, forKey: "email")
        aCoder.encodeObject(nickname, forKey: "nickname")
    }
}
