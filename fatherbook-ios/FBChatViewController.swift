//
//  FBChatViewController.swift
//  fatherbook-ios
//
//  Created by Monzy Zhang on 5/19/16.
//  Copyright © 2016 MonzyZhang. All rights reserved.
//

import UIKit

class FBChatViewController: RCConversationViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
