//
//  FBRecentChatListViewController.swift
//  fatherbook-ios
//
//  Created by Monzy Zhang on 5/14/16.
//  Copyright © 2016 MonzyZhang. All rights reserved.
//

import UIKit

class FBRecentChatListViewController: RCConversationListViewController {
    override func viewDidLoad() {
        //重写显示相关的接口，必须先调用super，否则会屏蔽SDK默认的处理
        super.viewDidLoad()

        //设置需要显示哪些类型的会话
        self.setDisplayConversationTypes([RCConversationType.ConversationType_PRIVATE.rawValue,
            RCConversationType.ConversationType_DISCUSSION.rawValue,
            RCConversationType.ConversationType_CHATROOM.rawValue,
            RCConversationType.ConversationType_GROUP.rawValue,
            RCConversationType.ConversationType_APPSERVICE.rawValue,
            RCConversationType.ConversationType_SYSTEM.rawValue])
        //设置需要将哪些类型的会话在会话列表中聚合显示
        self.setCollectionConversationType([RCConversationType.ConversationType_DISCUSSION.rawValue,
            RCConversationType.ConversationType_GROUP.rawValue])
    }

    //重写RCConversationListViewController的onSelectedTableRow事件
    override func onSelectedTableRow(conversationModelType: RCConversationModelType, conversationModel model: RCConversationModel!, atIndexPath indexPath: NSIndexPath!) {
        //打开会话界面
        let chat = RCConversationViewController(conversationType: model.conversationType, targetId: model.targetId)
        chat.title = model.targetId
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.pushViewController(chat, animated: true)
    }

    override func willDisplayConversationTableCell(cell: RCConversationBaseCell!, atIndexPath indexPath: NSIndexPath!) {

    }
}
