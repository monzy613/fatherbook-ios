//
//  FBUserInfoViewController.swift
//  fatherbook-ios
//
//  Created by Monzy Zhang on 5/16/16.
//  Copyright © 2016 MonzyZhang. All rights reserved.
//

import UIKit
import SnapKit
import SIAlertView
import MZGoogleStyleButton

class FBUserInfoViewController: UITableViewController {
    var userInfo: FBUserInfo?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    // MARK: - delegate
    // MARK: - Table view delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(FBUserTableViewCell.self), forIndexPath: indexPath) as! FBUserTableViewCell
            if let userInfo = userInfo {
                cell.configureContactCellWith(userInfo: userInfo)
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(FBAlbumPreviewTableViewCell.self), forIndexPath: indexPath) as! FBAlbumPreviewTableViewCell
            return cell
        case 2:
            //chat
            let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(FBButtonTableViewCell.self), forIndexPath: indexPath) as! FBButtonTableViewCell
            cell.button.backgroundColor = UIColor.fb_darkColor()
            cell.button.setTitle("私信", forState: .Normal)
            cell.configWithHandler({ (cell) in
                FBRCChatManager.startRCInViewController(self.navigationController!, targetUser: self.userInfo!)
            })
            return cell
        case 3:
            //unfollow / follow
            let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(FBButtonTableViewCell.self), forIndexPath: indexPath) as! FBButtonTableViewCell
            if let userInfo = userInfo {
                switch userInfo.relation {
                case .Follow:
                    //press to follow
                    cell.button.backgroundColor = UIColor.fb_grayColor()
                    cell.button.setTitle("关注", forState: .Normal)
                    cell.configWithHandler(followHandler)
                    break
                case .Followed, .TwoWayFollowed:
                    cell.button.backgroundColor = UIColor.fb_darkRedColor()
                    cell.button.setTitle("取消关注", forState: .Normal)
                    cell.configWithHandler(unfollowHandler)
                    break
                default:
                    break
                }
            }
            return cell
        default:
            return UITableViewCell()
        }
    }

    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(bgColor: UIColor.clearColor())
    }

    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15.0
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return CGRectGetWidth(UIScreen.mainScreen().bounds) * 0.232
        case 1:
            return CGRectGetWidth(UIScreen.mainScreen().bounds) * 0.208
        default:
            return CGRectGetWidth(UIScreen.mainScreen().bounds) * 0.1
        }
    }

    // MARK: - action
    private func setupTableView() {
        tableView.tableHeaderView = UIView(frame: CGRectMake(0, 0, 0, 15))
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.fb_lightGrayColor()
        tableView.registerClass(FBUserTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(FBUserTableViewCell.self))
        tableView.registerClass(FBAlbumPreviewTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(FBAlbumPreviewTableViewCell.self))
        tableView.registerClass(FBButtonTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(FBButtonTableViewCell.self))
    }

    // MARK: - handlers
    private func followHandler(cell: FBButtonTableViewCell) {
        if let userInfo = userInfo {
            FBApi.post(withURL: kFBApiFollow, parameters: [
                kAccount: FBUserManager.sharedManager().user.account!,
                kTargetID: userInfo.account!
                ], success: { json -> (Void) in
                    print(json)
                }, failure: { err -> (Void) in
                    print(err)
            })
            FBUserManager.sharedManager().user.updateFollowInfos(withUserInfo: userInfo)
        }
        cell.button.backgroundColor = UIColor.fb_darkRedColor()
        cell.button.setTitle("取消关注", forState: .Normal)
        cell.configWithHandler(unfollowHandler)
    }

    private func unfollowHandler(cell: FBButtonTableViewCell) {
        if let userInfo = userInfo {
            let alert = SIAlertView(title: "取消关注", andMessage: "确认取消关注用户: \(userInfo.nickname ?? "")?")
            alert.destructiveButtonColor = UIColor.fb_lightColor()
            alert.cancelButtonColor = UIColor.fb_darkColor()
            alert.buttonsListStyle = .Rows
            alert.addButtonWithTitle("是", type: .Destructive, backgroundColor: UIColor.fb_darkColor(), cornerRadius: 4.0, handler: {
                alertView in
                FBApi.post(withURL: kFBApiUnFollow, parameters: [
                    kAccount: FBUserManager.sharedManager().user.account!,
                    kTargetID: userInfo.account!
                    ], success: { json -> (Void) in
                        print(json)
                    }, failure: { err -> (Void) in
                        print(err)
                })
                FBUserManager.sharedManager().user.updateFollowInfos(withUserInfo: userInfo)
                cell.button.backgroundColor = UIColor.fb_grayColor()
                cell.button.setTitle("关注", forState: .Normal)
                cell.configWithHandler(self.followHandler)
            })
            alert.addButtonWithTitle("否", type: .Cancel, backgroundColor: UIColor.fb_lightColor(), cornerRadius: 4.0, handler:nil)
            alert.transitionStyle = .DropDown
            alert.show()
        }
    }
}
