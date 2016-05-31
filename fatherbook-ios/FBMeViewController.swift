//
//  FBMeViewController.swift
//  fatherbook-ios
//
//  Created by Monzy Zhang on 5/11/16.
//  Copyright © 2016 MonzyZhang. All rights reserved.
//

import UIKit
import Qiniu

class FBMeViewController: UITableViewController {

    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }


    // MARK: - delegate
    // MARK: FBUserTableViewCell delegate
    func avatarTouched(cell: FBUserTableViewCell) {
//        let token = "hXxhiug5AmKnXTSGECNFWy2Bo0QRzrDqo7bst8rS:lyCyA4jWzvdUuHaApbvuCTXdNWA=:eyJzY29wZSI6ImZhdGhlcmJvb2s6aGVsbG8udHh0IiwiZGVhZGxpbmUiOjE0NjM2NzM3NzR9"
//        let upManager = QNUploadManager()
//        let image = UIImage(named: "setting")!
//        let data = UIImagePNGRepresentation(image)
//        upManager.putData(data, key: "hello.txt", token: token, complete: { (info, key, response) in
//            print(info)
//            print(response)
//            }, option: nil)
    }

    // MARK: TableViewdelegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    // MARK: TableView datasource
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            //userinfo
            let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(FBUserTableViewCell.self), forIndexPath: indexPath) as! FBUserTableViewCell
            cell.avatarTouchHandler = avatarTouched
            cell.accessoryType = .DisclosureIndicator
            cell.configureContactCellWith(userInfo: FBUserManager.sharedManager().user)
            return cell
        case 1, 2:
            //timeline, setting
            let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(FBLeftIconTitleTableViewCell.self), forIndexPath: indexPath) as! FBLeftIconTitleTableViewCell
            cell.accessoryType = .DisclosureIndicator
            if indexPath.section == 1 {
                cell.config(withImage: UIImage(named: "dark-matters-normal"), title: "My Timeline")
            } else {
                cell.config(withImage: UIImage(named: "setting"), title: "Settings")
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
        case 1, 2:
            return CGRectGetWidth(UIScreen.mainScreen().bounds) * 0.15
        default:
            return 87
        }
    }

    // MARK: private
    private func setupTableView() {
        tableView.tableHeaderView = UIView(frame: CGRectMake(0, 0, 0, 15))
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.fb_darkColor()
        tableView.registerClass(FBUserTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(FBUserTableViewCell.self))
        tableView.registerClass(FBLeftIconTitleTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(FBLeftIconTitleTableViewCell.self))
    }
}
