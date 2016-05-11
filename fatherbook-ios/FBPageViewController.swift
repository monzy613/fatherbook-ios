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

class FBPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource, FBPageHeaderViewDelegate {

    // MARK: views
    var pageHeader: FBPageHeaderView!
    var topTabLayer: CAGradientLayer!
    var newTimelineButton: UIButton!

    let statusBarHeight: CGFloat = 20.0
    var openHeaderPropotion: CGFloat = 0.15


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
        FBApi.post(withURL: kFBApiSearchAccount, parameters: [kAccount: searchText], success: { (json) -> (Void) in
            if let status = json["status"].string {
                print("status: \(status)")
                if let users = json["users"].array {
                    MBProgressHUD.showSuccessToView(users.description, rootView: self.view)
                    print(users)
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

    func initSubviews() {
        pageHeader = FBPageHeaderView(width: CGRectGetWidth(view.bounds), openHeight: openHeaderHeight)
        pageHeader.delegate = self

        let buttonWidth = CGRectGetWidth(view.bounds) / 7
        newTimelineButton = UIButton(type: .System)
        newTimelineButton.addTarget(self, action: #selector(newTimelineButtonPressed), forControlEvents: .TouchUpInside)
        newTimelineButton.frame = CGRectMake(0, 0, buttonWidth, buttonWidth)
        newTimelineButton.center = CGPointMake(CGRectGetWidth(view.bounds) - buttonWidth * 0.85, CGRectGetHeight(view.bounds) - buttonWidth * 0.85)
        let circle = UIBezierPath(arcCenter: CGPointMake(buttonWidth / 2, buttonWidth / 2), radius: buttonWidth / 2, startAngle: 0, endAngle: CGFloat(M_PI * 2), clockwise: true)
        let circleLayer = CAShapeLayer()
        circleLayer.fillColor = UIColor(hex6: 0x535B6D).CGColor
        circleLayer.path = circle.CGPath
        circleLayer.frame = newTimelineButton.bounds
        newTimelineButton.layer.addSublayer(circleLayer)

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
        newTimelineButton.layer.shadowOpacity = 0.5
        newTimelineButton.layer.shadowOffset = CGSizeMake(1.0, 1.0)
        newTimelineButton.layer.addSublayer(plusLayer)

        view.addSubview(pageHeader)
        view.addSubview(newTimelineButton)
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

    // MARK: actions
    func newTimelineButtonPressed(sender: UIButton) {
    }
}
