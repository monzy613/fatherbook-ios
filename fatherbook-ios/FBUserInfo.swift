//
//  FBUserInfo.swift
//  fatherbook-ios
//
//  Created by Monzy Zhang on 16/5/9.
//  Copyright © 2016年 MonzyZhang. All rights reserved.
//

import UIKit
import SwiftyJSON

/**
 * the relation with current user
 *
 */
enum FBUserRelation {
    case Me
    case Follow
    case Followed
    case TwoWayFollowed
}

class FBUserInfo: NSObject, NSCoding {
    var account: String?
    var phone: String?
    var email: String?
    var nickname: String?
    var rcToken: String?
    var relation: FBUserRelation = .Me

    init(json: JSON) {
        super.init()
        account = json["account"].string ?? json["_id"].string
        phone = json["phone"].string
        email = json["email"].string
        nickname = json["nickname"].string
        rcToken = json["rcToken"].string

        //should set relation
        relation = .Follow
    }

    required init?(coder aDecoder: NSCoder) {
        super.init()
        account = aDecoder.decodeObjectForKey("account") as? String
        phone = aDecoder.decodeObjectForKey("phone") as? String
        email = aDecoder.decodeObjectForKey("email") as? String
        nickname = aDecoder.decodeObjectForKey("nickname") as? String
    }

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(account, forKey: "account")
        aCoder.encodeObject(phone, forKey: "phone")
        aCoder.encodeObject(email, forKey: "email")
        aCoder.encodeObject(nickname, forKey: "nickname")
    }
}
