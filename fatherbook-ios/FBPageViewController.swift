//
//  FBPageViewController.swift
//  fatherbook-ios
//
//  Created by Monzy Zhang on 16/5/9.
//  Copyright © 2016年 MonzyZhang. All rights reserved.
//

import UIKit
import SnapKit

class FBPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    // MARK: views
    var topTabBar: UIView!
    var topTabLayer: CAGradientLayer!


    var tabBarPropotion: CGFloat = 0.15


    var tabBarHeight: CGFloat {
        return tabBarPropotion * CGRectGetHeight(view.bounds)
    }

    var contentViewHeight: CGFloat {
        return CGRectGetHeight(view.bounds) - tabBarHeight
    }


    // MARK: inits
    override init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : AnyObject]?) {
        super.init(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: options)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        topTabBar = UIView()
        topTabLayer = CAGradientLayer()
        topTabLayer.colors = [UIColor(rgba: "#BBC1CC").CGColor, UIColor(rgba: "#010B21").CGColor]
        topTabLayer.frame = CGRectMake(0, 0, CGRectGetWidth(view.bounds), tabBarHeight)
        topTabBar.layer.addSublayer(topTabLayer)
        view.addSubview(topTabBar)
        setupConstraints()
    }

    func setupConstraints() {
        topTabBar.snp_makeConstraints { (make) in
            make.left.top.right.equalTo(view)
            make.height.equalTo(tabBarHeight)
        }
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let tsView = FBLoginViewController()
        tsView.view.frame = CGRectMake(0, tabBarHeight, CGRectGetWidth(view.bounds), contentViewHeight)
        return FBLoginViewController()
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let tsView = FBLoginViewController()
        tsView.view.frame = CGRectMake(0, tabBarHeight, CGRectGetWidth(view.bounds), contentViewHeight)
        return FBLoginViewController()
    }

    func tempVC() -> UIViewController {
        let vc = UIViewController()
        let colors = [UIColor.blueColor(), UIColor.blackColor(), UIColor.redColor(), UIColor.yellowColor()]
        let index: Int = Int(arc4random() % 4)
        vc.view.backgroundColor = colors[index]
        vc.view.frame = CGRectMake(0, tabBarHeight, CGRectGetWidth(view.bounds), contentViewHeight)
        return vc
    }
}
