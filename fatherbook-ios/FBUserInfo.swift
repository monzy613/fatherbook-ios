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
enum FBUserRelation: Int {
    case Me = -1
    case Follow = 0
    case Followed = 1
    case TwoWayFollowed = 2

    mutating func next() -> FBUserRelation {
        switch self {
        case .Follow:
            self = .Followed
            return .Followed
        case .Followed, .TwoWayFollowed:
            self = .Follow
            return .Follow
        default:
            return .Follow
        }
    }
}

class FBUserInfo: NSObject, NSCoding {
    var account: String?
    var phone: String?
    var email: String?
    var nickname: String?
    var rcToken: String?
    var relation: FBUserRelation = .Me
    var followInfos: [FBUserInfo]?

    func setFollowInfos(withJSON json: JSON) {
        if let follow_infos = json.array {
            followInfos = [FBUserInfo]()
            for infoJSON in follow_infos {
                let info = FBUserInfo(json: infoJSON)
                info.relation = FBUserRelation(rawValue: infoJSON["type"].int ?? 0) ?? .Follow
                followInfos?.append(info)
            }
        }
    }

    func updateFollowInfos(withUserInfo userInfo: FBUserInfo) {
        if let followInfos = self.followInfos {
            if followInfos.contains(userInfo) {
                if userInfo.relation != .Followed || userInfo.relation != .TwoWayFollowed {
                    self.followInfos!.removeAtIndex(followInfos.indexOf(userInfo)!)
                    return
                }
                let _index = followInfos.indexOf(userInfo)
                guard let index = _index else {return}
                self.followInfos![index] = userInfo
            } else {
                self.followInfos?.append(userInfo)
            }
        } else {
            self.followInfos = [FBUserInfo]()
        }
    }

    init(json: JSON) {
        super.init()
        account = json["account"].string ?? json["_id"].string
        phone = json["phone"].string
        email = json["email"].string
        nickname = json["nickname"].string
        rcToken = json["rcToken"].string

        //set relation
        let type = json["type"].int ?? 0
        relation = FBUserRelation(rawValue: type) ?? .Me
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

    override func isEqual(object: AnyObject?) -> Bool {
        if let rhs = object as? FBUserInfo {
            return rhs.account == self.account
        }
        return false
    }
}
