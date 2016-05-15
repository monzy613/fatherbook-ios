//
//  FBRootViewController.swift
//  fatherbook-ios
//
//  Created by Monzy Zhang on 5/16/16.
//  Copyright © 2016 MonzyZhang. All rights reserved.
//

import UIKit
import SnapKit
import MBProgressHUD
import MZGoogleStyleButton
import FXBlurView
import SIAlertView

class FBRootViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource, UITableViewDelegate, UITableViewDataSource, FBPageHeaderViewDelegate, FBUserTableViewCellDelegate {
    private lazy var pageHeader: FBPageHeaderView = {
        let _pageHeader = FBPageHeaderView(width: CGRectGetWidth(self.view.bounds), openHeight: self.openHeaderHeight)
        _pageHeader.delegate = self
        return _pageHeader
    }()

    // MARK: views
    private lazy var newTimelineButton: MZGoogleStyleButton = {
        let buttonWidth = CGRectGetWidth(self.view.bounds) / 7
        let _newTimelineButton = MZGoogleStyleButton(type: .System)
        _newTimelineButton.addTarget(self, action: #selector(newTimelineButtonPressed), forControlEvents: .TouchUpInside)
        _newTimelineButton.frame = CGRectMake(0, 0, buttonWidth, buttonWidth)
        _newTimelineButton.center = CGPointMake(CGRectGetWidth(self.view.bounds) - buttonWidth * 0.85, CGRectGetHeight(self.view.bounds) - buttonWidth * 0.85)
        _newTimelineButton.backgroundColor = UIColor(hex6: 0x535B6D)
        _newTimelineButton.layer.cornerRadius = buttonWidth / 2

        let plus = UIBezierPath()
        plus.moveToPoint(CGPointMake(buttonWidth / 4, buttonWidth / 2))
        plus.addLineToPoint(CGPointMake(buttonWidth * 3 / 4, buttonWidth / 2))
        plus.moveToPoint(CGPointMake(buttonWidth / 2, buttonWidth / 4))
        plus.addLineToPoint(CGPointMake(buttonWidth / 2, buttonWidth * 3 / 4))
        let plusLayer = CAShapeLayer()
        plusLayer.path = plus.CGPath
        plusLayer.strokeColor = UIColor.whiteColor().CGColor
        plusLayer.lineCap = kCALineCapRound
        plusLayer.frame = _newTimelineButton.bounds
        plusLayer.lineWidth = floor(0.07 * buttonWidth)
        _newTimelineButton.layer.addSublayer(plusLayer)
        return _newTimelineButton
    }()

    let statusBarHeight: CGFloat = 20.0
    var openHeaderPropotion: CGFloat = 0.15

    var searchResultToggled = false
    var newTimelineButtonToggled = true
    var searchResultView: UITableView?
    var searchBlurView: FXBlurView?
    var searchResultDataSource = [FBUserInfo]()
    var searchViewLastContentOffset: CGFloat = 0.0

    // page
    var currentIndex = 0
    var isDraggingRight = false
    private lazy var timeLineViewController: FBTimelineViewController = {
        let _timeLineViewController = FBTimelineViewController()
        _timeLineViewController.view.tag = 0
        return _timeLineViewController
    }()

    private lazy var recentChatViewController: FBRecentChatListViewController = {
        let _recentChatViewController = FBRecentChatListViewController()
        _recentChatViewController.view.tag = 1
        return _recentChatViewController
    }()

    private lazy var contactViewController: FBContactViewController = {
        let _contactViewController = FBContactViewController()
        _contactViewController.rootViewController = self
        _contactViewController.view.tag = 2
        return _contactViewController
    }()

    private lazy var meViewController: FBMeViewController = {
        let _meViewController = FBMeViewController()
        _meViewController.view.tag = 3
        return _meViewController
    }()


    var openHeaderHeight: CGFloat {
        return openHeaderPropotion * CGRectGetHeight(view.bounds)
    }

    var contentViewHeight: CGFloat {
        return CGRectGetHeight(view.bounds) - openHeaderHeight
    }


    var pageViewController: FBScrollPageViewController!

    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.fb_lightColor()
        pageViewController = FBScrollPageViewController()
        addChildViewController(pageViewController)
        view.addSubview(pageViewController.view)
        view.addSubview(pageHeader)
        view.addSubview(newTimelineButton)
        pageViewController.view.frame = CGRectMake(0, openHeaderHeight + 20.0, CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds) - openHeaderHeight)
        pageViewController.delegate = self
        pageViewController.dataSource = self
        for subview in pageViewController.view.subviews {
            if subview.isKindOfClass(UIScrollView) {
                (subview as! UIScrollView).delegate = self
            }
        }
        pageViewController.setViewControllers([timeLineViewController], direction: .Forward, animated: false, completion: nil)
    }

    // MARK: delegate
    // MARK: FBPageHeaderViewDelegate
    func searchTextDidChange(headerView headerView: FBPageHeaderView, searchText: String) {
        print(searchText)
    }

    func searchTextDidReturn(headerView headerView: FBPageHeaderView, searchText: String) {
        if searchText.characters.count == 0 {
            MBProgressHUD.showErrorToView("Please Enter Query string", rootView: self.view)
            return
        }
        let hud = MBProgressHUD.showLoadingToView(rootView: self.view)
        FBApi.post(withURL: kFBApiSearchAccount, parameters: [kAccount: FBUserManager.sharedManager().user.account!, kSearchString: searchText], success: { (json) -> (Void) in
            hud.hide(true, afterDelay: 0.0)
            self.searchResultDataSource = []
            if let status = json["status"].string {
                print("status: \(status)")
                if let users = json["users"].array {
                    for user in users {
                        let userInfo = FBUserInfo(json: user)
                        if let followInfos = FBUserManager.sharedManager().user.followInfos {
                            if followInfos.contains(userInfo) {
                                let relation = followInfos[followInfos.indexOf(userInfo) ?? 0].relation
                                userInfo.relation = relation
                            }
                        }
                        self.searchResultDataSource.append(userInfo)
                    }
                    dispatch_async(dispatch_get_main_queue(), {
                        self.searchResultView?.reloadData()
                    })
                } else {
                    MBProgressHUD.showErrorToView(FBApi.statusDescription(status).0, rootView: self.view)
                }
            } else {
            }
        }) { (error) -> (Void) in
        }
        headerView.endEditing(true)
    }

    func willShowSearchTextField(headerView headerView: FBPageHeaderView) {
        toggleResult()
    }

    func willDismissSearchTextField(headerView headerView: FBPageHeaderView) {
        toggleResult()
    }

    func timelineButtonPressed(headerView headerView: FBPageHeaderView) {
        setViewController(timeLineViewController)
    }

    func chatButtonPressed(headerView headerView: FBPageHeaderView) {
        setViewController(recentChatViewController)
    }

    func contactButtonPressed(headerView headerView: FBPageHeaderView) {
        setViewController(contactViewController)
    }

    func meButtonPressed(headerView headerView: FBPageHeaderView) {
        setViewController(meViewController)
    }


    // MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    // MARK: UIScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView == searchResultView {
            if scrollView.contentOffset.y - searchViewLastContentOffset > 10.0 {
                pageHeader.endSearch()
            }
            searchViewLastContentOffset = scrollView.contentOffset.y
            return
        }
        //        let point = scrollView.contentOffset
        //        let percentComplete = (point.x + CGFloat(currentIndex - 1) * CGRectGetWidth(view.bounds)) / (4.0 * CGRectGetWidth(view.bounds))
        //        if percentComplete == 0.0 {
        //            return
        //        }
        //        print(String(format: "%.02f", percentComplete) + ", \(currentIndex)")
        //        pageHeader.moveTo(percentComplete)
    }

    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == searchResultView {
            return
        }
        if velocity.x > 0 {
            //-->
            isDraggingRight = true
        } else if velocity.x < 0 {
            //<--
            isDraggingRight = false
        }
    }

    // MARK: FBUserTableViewCellDelegate
    func actionButtonPressedInCell(cell: FBUserTableViewCell) {
        guard let indexPath = searchResultView?.indexPathForCell(cell) else {
            return
        }
        if searchResultDataSource.count > indexPath.row {
            let userInfo = searchResultDataSource[indexPath.row]
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
                contactViewController.tableView.reloadData()
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
                    self.contactViewController.tableView.reloadData()
                })
                alert.addButtonWithTitle("否", type: .Cancel, backgroundColor: UIColor.fb_lightColor(), cornerRadius: 4.0, handler:nil)
                alert.transitionStyle = .DropDown
                alert.show()
            default:
                break
            }
        }
    }

    // MARK: dataSource
    // MARK: UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResultDataSource.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(FBUserTableViewCell.self.description(), forIndexPath: indexPath) as! FBUserTableViewCell
        cell.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.5)
        if cell.delegate == nil {
            cell.delegate = self
        }
        if (searchResultDataSource.count > indexPath.row) {
            cell.configureWith(userInfo: searchResultDataSource[indexPath.row])
        }
        return cell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 87.0
    }

    // MARK: UIPageViewDataSource
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var beforeVC: UIViewController!
        switch viewController {
        case recentChatViewController:
            beforeVC = timeLineViewController
        case contactViewController:
            beforeVC = recentChatViewController
        case meViewController:
            beforeVC = contactViewController
        default:
            beforeVC = nil
        }
        return beforeVC
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var afterVC: UIViewController!
        switch viewController {
        case timeLineViewController:
            afterVC = recentChatViewController
        case recentChatViewController:
            afterVC = contactViewController
        case contactViewController:
            afterVC = meViewController
        default:
            afterVC = nil
        }
        return afterVC
    }

    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if !completed {
            return
        }
        if isDraggingRight {
            currentIndex = previousViewControllers[0].view.tag + 1
        } else {
            currentIndex = (previousViewControllers[0].view.tag - 1) < 0 ?0 : previousViewControllers[0].view.tag - 1
        }
        pageHeader.moveTo(index: currentIndex)
    }

    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController]) {
        if (pendingViewControllers[0] != timeLineViewController && newTimelineButtonToggled) || (pendingViewControllers[0] == timeLineViewController) {
            toggleNewTimelineButton()
        }
        if isDraggingRight {
            currentIndex = pendingViewControllers[0].view.tag + 1
        } else {
            currentIndex = (pendingViewControllers[0].view.tag - 1) < 0 ?0 : pendingViewControllers[0].view.tag - 1
        }
    }

    // MARK: - actions
    func newTimelineButtonPressed(sender: UIButton) {
    }

    // MARK: private
    private func toggleNewTimelineButton() {
        let buttonWidth = CGRectGetWidth(self.view.bounds) / 7
        var newCenter: CGPoint
        if newTimelineButtonToggled {
            newCenter = CGPointMake(CGRectGetWidth(self.view.bounds) - buttonWidth * 0.85, CGRectGetHeight(self.view.bounds) + buttonWidth / 2)
        } else {
            newCenter = CGPointMake(CGRectGetWidth(self.view.bounds) - buttonWidth * 0.85, CGRectGetHeight(self.view.bounds) - buttonWidth * 0.85)
        }
        UIView.animateWithDuration(0.25) {
            self.newTimelineButton.center = newCenter
        }
        newTimelineButtonToggled = !newTimelineButtonToggled
    }

    private func toggleResult() {
        // TODO: blur view may not dismiss on simulator because of NSTimer
        if searchResultToggled {
            searchBlurView?.blurAnimation(from: 40.0, to: 0.0, duration: 0.25, completion: {
                self.searchBlurView?.alpha = 0.0
                self.searchBlurView?.removeFromSuperview()
                self.searchBlurView = nil
            })
            UIView.animateWithDuration(0.25, animations: {
                self.searchResultView?.alpha = 0.0
                }, completion: { (finished) in
                    self.searchResultDataSource = []
                    self.searchResultView?.removeFromSuperview()
                    self.searchResultView = nil
            })
        } else {
            if searchResultView == nil {
                searchResultView = UITableView()
                searchResultView?.backgroundColor = UIColor.clearColor()
                searchResultView?.delegate = self
                searchResultView?.dataSource = self
                searchResultView?.registerClass(FBUserTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(FBUserTableViewCell.self))
                searchResultView?.tableFooterView = UIView()
                searchResultView?.separatorStyle = .SingleLine
                view.addSubview(searchResultView!)
                searchResultView?.snp_makeConstraints(closure: { (make) in
                    make.left.right.bottom.equalTo(view)
                    make.top.equalTo(view).offset(pageHeader.closeHeight)
                })
            }
            if searchBlurView == nil {
                let blurFrame = CGRectMake(0, pageHeader.closeHeight, CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds) - pageHeader.closeHeight)
                searchBlurView = FXBlurView(frame: blurFrame)
                searchBlurView!.tintColor = UIColor.blackColor()
                view.insertSubview(searchBlurView!, belowSubview: searchResultView!)
            }
            searchResultView?.alpha = 0.0
            searchBlurView?.alpha = 1.0
            searchBlurView!.blurAnimation(from: 0.0, to: 40.0, duration: 0.25, completion: nil)
            UIView.animateWithDuration(0.25, animations: {
                self.searchResultView?.alpha = 1.0
            })
        }
        searchResultToggled = !searchResultToggled
    }

    private func setViewController(viewController: UIViewController) {
        let tag = viewController.view.tag
        if currentIndex == tag {
            return
        }
        var animationDirection: UIPageViewControllerNavigationDirection
        if currentIndex < tag {
            animationDirection = .Forward
        } else {
            animationDirection = .Reverse
        }
        pageViewController.setViewControllers([viewController], direction: animationDirection, animated: true) { (finished) in
            if finished {
                self.currentIndex = tag
            }
        }
    }
}
