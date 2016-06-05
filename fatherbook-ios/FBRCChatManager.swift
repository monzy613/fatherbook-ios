//
//  FBRCChatManager.swift
//  fatherbook-ios
//
//  Created by Monzy Zhang on 5/16/16.
//  Copyright © 2016 MonzyZhang. All rights reserved.
//

class FBRCChatManager {

    var rcToken: String?

    private static var sharedInstance: FBRCChatManager?

    class func sharedManager() -> FBRCChatManager {
        if sharedInstance == nil {
            sharedInstance = FBRCChatManager()
        }
        return sharedInstance!
    }

    private init() {

    }


    class func initRC() {
        RCIM.sharedRCIM().initWithAppKey(FBConsts.sharedInstance.kRongCloudAppKey)
        guard let token = sharedManager().rcToken else {
            return
        }
        RCIM.sharedRCIM().connectWithToken(
            token,
            success: { (userId) -> Void in
                print("登陆成功。当前登录的用户ID：\(userId)")
                FBUserManager.sharedManager().rcInitSuccess = true
                FBPersist.set(value: sharedManager().rcToken, forKey: .RCToken)
            }, error: { (status) -> Void in
                print("登陆的错误码为:\(status.rawValue)")
            }, tokenIncorrect: {
                //token过期或者不正确。
                //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
                //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
                print("token错误")
        })
    }

    class func startRCInViewController(vc: UIViewController, targetUser: FBUserInfo) {
        let chatVC = RCConversationViewController()
        //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
        chatVC.conversationType = RCConversationType.ConversationType_PRIVATE
        //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
        chatVC.targetId = targetUser.account ?? ""
        //设置聊天会话界面要显示的标题
        chatVC.title = targetUser.nickname ?? "null"
        //显示聊天会话界面
        dispatch_async(dispatch_get_main_queue(), {
            if let naviVC = (vc as? UINavigationController) {
                naviVC.pushViewController(chatVC, animated: true)
                naviVC.viewControllers.fb_safeRemoveObjectAdIndex(1)
                if let rootVC = naviVC.viewControllers.fb_safeObjectAtIndex(0) as? FBRootViewController {
                    rootVC.chatButtonPressed(headerView: rootVC.pageHeader)
                }
            } else {
                vc.presentViewController(chatVC, animated: true, completion: nil)
            }
        })
    }
}