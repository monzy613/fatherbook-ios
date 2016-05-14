//
//  FBPageViewController.swift
//  fatherbook-ios
//
//  Created by Monzy Zhang on 16/5/9.
//  Copyright © 2016年 MonzyZhang. All rights reserved.
//

import UIKit
import SnapKit
import MBProgressHUD
import MZGoogleStyleButton
import FXBlurView

class FBPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource, UITableViewDelegate, UITableViewDataSource, FBPageHeaderViewDelegate {

    // MARK: views
    var pageHeader: FBPageHeaderView!
    var topTabLayer: CAGradientLayer!
    var newTimelineButton: MZGoogleStyleButton!

    let statusBarHeight: CGFloat = 20.0
    var openHeaderPropotion: CGFloat = 0.15

    var searchResultToggled = false
    var searchResultView: UITableView?
    var searchBlurView: FXBlurView?
    var searchResultDataSource = [FBUserInfo]()
    var searchViewLastContentOffset: CGFloat = 0.0

    // page
    var currentIndex = 0
    var isDraggingRight = false
    var timeLineViewController: FBTimelineViewController!
    var recentChatViewController: FBRecentChatListViewController!
    var contactViewController: FBContactViewController!
    var meViewController: FBMeViewController!


    var openHeaderHeight: CGFloat {
        return openHeaderPropotion * CGRectGetHeight(view.bounds)
    }

    var contentViewHeight: CGFloat {
        return CGRectGetHeight(view.bounds) - openHeaderHeight
    }


    // MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        for subview in view.subviews {
            if subview.isKindOfClass(UIScrollView) {
                (subview as! UIScrollView).delegate = self
            }
        }

        initSubviews()
        setupViewControllers()
        self.setViewControllers([timeLineViewController], direction: .Forward, animated: false, completion: nil)
    }

    // MARK: inits
    override init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : AnyObject]?) {
        super.init(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: options)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: delegate
    // MARK: FBPageHeaderViewDelegate
    func searchTextDidChange(headerView view: FBPageHeaderView, searchText: String) {
        print(searchText)
    }

    func searchTextDidReturn(headerView view: FBPageHeaderView, searchText: String) {
        let hud = MBProgressHUD.showLoadingToView(rootView: self.view)
        FBApi.post(withURL: kFBApiSearchAccount, parameters: [kAccount: searchText], success: { (json) -> (Void) in
            hud.hide(true, afterDelay: 0.0)
            self.searchResultDataSource = []
            if let status = json["status"].string {
                print("status: \(status)")
                if let users = json["users"].array {
                    for user in users {
                        let userInfo = FBUserInfo(json: user)
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
        view.endEditing(true)
    }

    func willShowSearchTextField(headerView view: FBPageHeaderView) {
        toggleResult()
    }

    func willDismissSearchTextField(headerView view: FBPageHeaderView) {
        toggleResult()
    }

    func timelineButtonPressed(headerView view: FBPageHeaderView) {
        setViewController(timeLineViewController)
    }

    func chatButtonPressed(headerView view: FBPageHeaderView) {
        setViewController(recentChatViewController)
    }

    func contactButtonPressed(headerView view: FBPageHeaderView) {
        setViewController(contactViewController)
    }

    func meButtonPressed(headerView view: FBPageHeaderView) {
        setViewController(meViewController)
    }

    // MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    // MARK: UIScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y - searchViewLastContentOffset > 7.0 {
            pageHeader.endSearch()
        }
        searchViewLastContentOffset = scrollView.contentOffset.y
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
            currentIndex = previousViewControllers[0].view.tag - 1
        }
        pageHeader.moveTo(index: currentIndex)
        print("pre: \(previousViewControllers)")
    }

    // MARK: actions
    func newTimelineButtonPressed(sender: UIButton) {
    }

    // MARK: private
    private func setupViewControllers() {
        timeLineViewController = FBTimelineViewController()
        timeLineViewController.view.tag = 0
        timeLineViewController.view.frame = CGRectMake(0, openHeaderHeight + statusBarHeight, CGRectGetWidth(view.bounds), contentViewHeight)

        recentChatViewController = FBRecentChatListViewController()
        recentChatViewController.view.tag = 1
        recentChatViewController.view.frame = CGRectMake(0, openHeaderHeight + statusBarHeight, CGRectGetWidth(view.bounds), contentViewHeight)

        contactViewController = FBContactViewController()
        contactViewController.view.tag = 2
        contactViewController.view.frame = CGRectMake(0, openHeaderHeight + statusBarHeight, CGRectGetWidth(view.bounds), contentViewHeight)

        meViewController = FBMeViewController()
        meViewController.view.tag = 3
        meViewController.view.frame = CGRectMake(0, openHeaderHeight + statusBarHeight, CGRectGetWidth(view.bounds), contentViewHeight)
    }

    func toggleResult() {
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
                searchResultView?.registerClass(FBUserTableViewCell.self, forCellReuseIdentifier: FBUserTableViewCell.self.description())
                searchResultView?.tableFooterView = UIView()
                searchResultView?.separatorStyle = .SingleLine
                view.addSubview(searchResultView!)
                searchResultView?.snp_makeConstraints(closure: { (make) in
                    make.left.right.bottom.equalTo(view)
                    make.top.equalTo(pageHeader.snp_bottom)
                })
            }
            if searchBlurView == nil {
                searchBlurView = FXBlurView(frame: view.bounds)
                searchBlurView!.tintColor = UIColor.clearColor()
                view.insertSubview(searchBlurView!, belowSubview: pageHeader)
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

    func initSubviews() {
        pageHeader = FBPageHeaderView(width: CGRectGetWidth(view.bounds), openHeight: openHeaderHeight)
        pageHeader.delegate = self

        let buttonWidth = CGRectGetWidth(view.bounds) / 7
        newTimelineButton = MZGoogleStyleButton(type: .System)
        newTimelineButton.addTarget(self, action: #selector(newTimelineButtonPressed), forControlEvents: .TouchUpInside)
        newTimelineButton.frame = CGRectMake(0, 0, buttonWidth, buttonWidth)
        newTimelineButton.center = CGPointMake(CGRectGetWidth(view.bounds) - buttonWidth * 0.85, CGRectGetHeight(view.bounds) - buttonWidth * 0.85)
        newTimelineButton.backgroundColor = UIColor(hex6: 0x535B6D)
        newTimelineButton.layer.cornerRadius = buttonWidth / 2

        let plus = UIBezierPath()
        plus.moveToPoint(CGPointMake(buttonWidth / 4, buttonWidth / 2))
        plus.addLineToPoint(CGPointMake(buttonWidth * 3 / 4, buttonWidth / 2))
        plus.moveToPoint(CGPointMake(buttonWidth / 2, buttonWidth / 4))
        plus.addLineToPoint(CGPointMake(buttonWidth / 2, buttonWidth * 3 / 4))
        let plusLayer = CAShapeLayer()
        plusLayer.path = plus.CGPath
        plusLayer.strokeColor = UIColor.whiteColor().CGColor
        plusLayer.lineCap = kCALineCapRound
        plusLayer.frame = newTimelineButton.bounds
        plusLayer.lineWidth = floor(0.07 * buttonWidth)
        newTimelineButton.layer.addSublayer(plusLayer)

        view.addSubview(pageHeader)
        view.addSubview(newTimelineButton)

        guard  let statusBar = UIApplication.sharedApplication().valueForKey("statusBarWindow")?.valueForKey("statusBar") as? UIView else {
            return
        }

        statusBar.backgroundColor = UIColor.fb_lightColor()
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
        setViewControllers([viewController], direction: animationDirection, animated: true) { (finished) in
            if finished {
                self.currentIndex = tag
            }
        }
    }
}
