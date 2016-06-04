//
//  FBMeViewController.swift
//  fatherbook-ios
//
//  Created by Monzy Zhang on 5/11/16.
//  Copyright © 2016 MonzyZhang. All rights reserved.
//

import UIKit
import Qiniu
import BUKImagePickerController
import BUKPhotoEditViewController
import SDWebImage

class FBMeViewController: UITableViewController, BUKImagePickerControllerDelegate, BUKPhotoEditViewControllerDelegate {
    lazy var imagePickerNavigationController: UINavigationController! = {
        let navigationController = UINavigationController()
        navigationController.navigationBarHidden = true
        return navigationController
    }()
    var imagePicker: BUKImagePickerController!

    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }


    // MARK: - delegate
    // MARK: FBUserTableViewCell delegate
    func avatarTouched(cell: FBUserTableViewCell) {
        imagePicker = BUKImagePickerController()
        imagePicker?.allowsMultipleSelection = false
        imagePicker?.delegate = self
        imagePickerNavigationController.pushViewController(imagePicker, animated: false)
        presentViewController(imagePickerNavigationController, animated: true, completion: nil)
    }


    // MARK: - delegate -
    // MARK: - BUKImagePickerControllerDelegate
    func buk_imagePickerController(imagePickerController: BUKImagePickerController!, didFinishPickingAssets assets: [AnyObject]!) {
        print("didFinishPickingAssets")
        if assets.count == 0 {
            return
        }
        let asset = (assets[0] as! ALAsset)
        let image = UIImage(CGImage: asset.defaultRepresentation().fullScreenImage().takeUnretainedValue())
        let photoEditViewController = BUKPhotoEditViewController(photo: image)
        photoEditViewController.delegate = self
        imagePickerNavigationController.pushViewController(photoEditViewController, animated: true)
    }

    func buk_imagePickerControllerDidCancel(imagePickerController: BUKImagePickerController!) {
        imagePickerNavigationController.dismissViewControllerAnimated(true, completion: nil)
    }


    // MARK: BUKPhotoEditViewControllerDelegate
    func buk_photoEditViewController(controller: BUKPhotoEditViewController!, didFinishEditingPhoto photo: UIImage!) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let data = UIImageJPEGRepresentation(photo, 1.0)
            dispatch_async(dispatch_get_main_queue()) {
                FBApi.post(withURL: kFBApiChangeAvatar, parameters: [kAccount: FBUserManager.sharedManager().user.account!], success: { (json) -> (Void) in
                    if let token = json[kToken].string, let filename = json[kFilename].string {
                        let upManager = QNUploadManager()
                        upManager.putData(data, key: filename, token: token, complete: { (info, key, response) in
                            guard let info = info else {return}
                            if !info.ok {
                                return
                            }
                            FBApi.post(withURL: kFBApiChangeAvatarSuccess, parameters: [
                                kAccount: FBUserManager.sharedManager().user.account!
                                ], success: { (json) -> (Void) in
                                    dispatch_async(dispatch_get_main_queue(), {
                                        FBGlobalMethods.removeLocaleImage(withURL: NSURL(string: FBUserManager.sharedManager().user.avatarURL))
                                        (self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! FBUserTableViewCell).configureContactCellWith(userInfo: FBUserManager.sharedManager().user)
                                    })
                                }, failure: { (err) -> (Void) in
                            })
                            }, option: nil)
                    }
                }) { (err) -> (Void) in
                    print("err in \(kFBApiChangeAvatar): \(err)")
                }
            }
        }
        imagePickerNavigationController.dismissViewControllerAnimated(true, completion: nil)
    }

    func buk_photoEditViewControllerDidCancelEditingPhoto(controller: BUKPhotoEditViewController!) {
        imagePickerNavigationController.dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - TableViewdelegate
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
            let cell = tableView.dequeueReusableCellWithIdentifier(FBUserTableViewCell.description(), forIndexPath: indexPath) as! FBUserTableViewCell
            cell.avatarTouchHandler = avatarTouched
            cell.accessoryType = .DisclosureIndicator
            if cell.imageView?.image == nil {
                cell.configureContactCellWith(userInfo: FBUserManager.sharedManager().user)
            }
            return cell
        case 1, 2:
            //timeline, setting
            let cell = tableView.dequeueReusableCellWithIdentifier(FBLeftIconTitleTableViewCell.description(), forIndexPath: indexPath) as! FBLeftIconTitleTableViewCell
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
        tableView.registerClass(FBUserTableViewCell.self, forCellReuseIdentifier: FBUserTableViewCell.description())
        tableView.registerClass(FBLeftIconTitleTableViewCell.self, forCellReuseIdentifier: FBLeftIconTitleTableViewCell.description())
    }
}
