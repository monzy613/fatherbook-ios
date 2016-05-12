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

class FBPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource, UITableViewDelegate, UITableViewDataSource, FBPageHeaderViewDelegate {

    // MARK: views
    var pageHeader: FBPageHeaderView!
    var topTabLayer: CAGradientLayer!
    // TODO: subclass uibutton to make some animations / use tap gesture
    var newTimelineButton: MZGoogleStyleButton!

    let statusBarHeight: CGFloat = 20.0
    var openHeaderPropotion: CGFloat = 0.15

    var searchResultToggled = false
    var searchResultView: UITableView!
    var searchResultDataSource = [FBUserInfo]()


    var openHeaderHeight: CGFloat {
        return openHeaderPropotion * CGRectGetHeight(view.bounds)
    }

    var contentViewHeight: CGFloat {
        return CGRectGetHeight(view.bounds) - openHeaderHeight
    }


    // MARK: inits
    override init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : AnyObject]?) {
        super.init(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: options)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: FBPageHeaderViewDelegate
    func searchTextDidChange(headerView view: FBPageHeaderView, searchText: String) {
        print(searchText)
    }

    func searchTextDidReturn(headerView view: FBPageHeaderView, searchText: String) {
        let hud = MBProgressHUD.showLoadingToView(rootView: view)
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
                        self.searchResultView.reloadData()
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

    }

    func chatButtonPressed(headerView view: FBPageHeaderView) {

    }

    func contactButtonPressed(headerView view: FBPageHeaderView) {

    }

    func meButtonPressed(headerView view: FBPageHeaderView) {

    }

    // MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViewControllers([tempVC()], direction: .Forward, animated: false, completion: nil)
        self.delegate = self
        self.dataSource = self
        initSubviews()
    }

    func toggleResult() {
        if searchResultToggled {
            UIView.animateWithDuration(0.25, animations: {
                self.searchResultView.alpha = 0.0
                }, completion: { (finished) in
                    self.searchResultView.removeFromSuperview()
                    self.searchResultView = nil
            })
        } else {
            searchResultView = UITableView()
            searchResultView.delegate = self
            searchResultView.dataSource = self
            searchResultView.registerClass(FBUserTableViewCell.self, forCellReuseIdentifier: FBUserTableViewCell.self.description())
            searchResultView.tableFooterView = UIView()
            view.addSubview(searchResultView)
            searchResultView.alpha = 0.0
            searchResultView.snp_makeConstraints(closure: { (make) in
                make.left.right.bottom.equalTo(view)
                make.top.equalTo(pageHeader.snp_bottom)
            })
            UIView.animateWithDuration(0.25, animations: {
                self.searchResultView.alpha = 1.0
                }, completion: { (finished) in
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

    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let tsView = FBLoginViewController()
        tsView.view.frame = CGRectMake(0, openHeaderHeight + statusBarHeight, CGRectGetWidth(view.bounds), contentViewHeight)
        return FBLoginViewController()
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let tsView = FBLoginViewController()
        tsView.view.frame = CGRectMake(0, openHeaderHeight + statusBarHeight, CGRectGetWidth(view.bounds), contentViewHeight)
        return FBTimelineViewController()
    }

    func tempVC() -> UIViewController {
        let vc = UIViewController()
        let colors = [UIColor.blueColor(), UIColor.blackColor(), UIColor.redColor(), UIColor.yellowColor()]
        let index: Int = Int(arc4random() % 4)
        vc.view.backgroundColor = colors[index]
        vc.view.frame = CGRectMake(0, openHeaderHeight + statusBarHeight, CGRectGetWidth(view.bounds), contentViewHeight)
        return vc
    }

    // MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    // MARK: UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResultDataSource.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(FBUserTableViewCell.self.description(), forIndexPath: indexPath) as! FBUserTableViewCell
        if (searchResultDataSource.count > indexPath.row) {
            cell.configureWith(userInfo: searchResultDataSource[indexPath.row])
        }
        return cell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 87.0
    }

    // MARK: actions
    func newTimelineButtonPressed(sender: UIButton) {
    }
}
