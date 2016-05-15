//
//  FBContactViewController.swift
//  fatherbook-ios
//
//  Created by Monzy Zhang on 5/11/16.
//  Copyright © 2016 MonzyZhang. All rights reserved.
//

import UIKit
import SIAlertView

class FBContactViewController: UITableViewController, FBUserTableViewCellDelegate {
    var rootViewController: FBRootViewController?

    // MARK: - life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.registerClass(FBUserTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(FBUserTableViewCell.self))
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - delegate -
    // MARK: FBUserTableViewCellDelegate
    func actionButtonPressedInCell(cell: FBUserTableViewCell) {
        guard let indexPath = tableView.indexPathForCell(cell), let contactInfos = FBUserManager.sharedManager().user.followInfos else {
            return
        }
        if contactInfos.count > indexPath.row {
            let userInfo = contactInfos[indexPath.row]
            switch userInfo.relation {
            case .Follow:
                //press to follow
                FBApi.post(withURL: kFBApiFollow, parameters: [
                    kAccount: FBUserManager.sharedManager().user.account!,
                    kTargetID: userInfo.account!
                    ], success: { json -> (Void) in
                        print(json)
                    }, failure: { err -> (Void) in
                        print(err)
                })
                cell.setStateWithRelation(userInfo.relation.next())
                FBUserManager.sharedManager().user.updateFollowInfos(withUserInfo: userInfo)
                tableView.reloadData()
            case .Followed, .TwoWayFollowed:
                //press to unfollow
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
                    cell.setStateWithRelation(userInfo.relation.next())
                    FBUserManager.sharedManager().user.updateFollowInfos(withUserInfo: userInfo)
                    self.tableView.reloadData()
                })
                alert.addButtonWithTitle("否", type: .Cancel, backgroundColor: UIColor.fb_lightColor(), cornerRadius: 4.0, handler:nil)
                alert.transitionStyle = .DropDown
                alert.show()
            default:
                break
            }
        }
    }

    // MARK: - Table view delegate

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(section)"
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let count = FBUserManager.sharedManager().user.followInfos?.count else {
            return 0
        }
        return count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(FBUserTableViewCell.self.description(), forIndexPath: indexPath) as! FBUserTableViewCell
        cell.backgroundColor = UIColor.whiteColor()
        guard let count = FBUserManager.sharedManager().user.followInfos?.count else {
            return cell
        }
        if cell.delegate == nil {
            cell.delegate = self
        }
        if (count > indexPath.row) {
            cell.configureWith(userInfo: FBUserManager.sharedManager().user.followInfos![indexPath.row])
        }
        return cell
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 87.0
    }
}
