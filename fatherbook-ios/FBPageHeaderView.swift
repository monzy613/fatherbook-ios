//
//  FBPageHeaderView.swift
//  fatherbook-ios
//
//  Created by Monzy Zhang on 5/11/16.
//  Copyright © 2016 MonzyZhang. All rights reserved.
//

import UIKit
import SnapKit
import UIColor_Hex_Swift

private let indicateBarHeight: CGFloat = 7.0
private let statusBarHeight: CGFloat = 20.0
class FBPageHeaderView: UIView {
    var pageTitleLabel: UILabel!
    var searchButton: UIButton!
    var timelineButton: UIButton!
    var chatButton: UIButton!
    var contactsButton: UIButton!
    var meButton: UIButton!
    var indicateBar: UIView!
    var gradientBackground: CAGradientLayer!

    var width: CGFloat = 0
    var closeHeight: CGFloat = 0
    var openHeight: CGFloat = 0


    // MARK: init
    convenience init(width: CGFloat, openHeight: CGFloat) {
        self.init(frame: CGRectMake(0, statusBarHeight, width, openHeight))
        self.width = width
        self.openHeight = openHeight
        self.closeHeight = (openHeight - indicateBarHeight) / 2
        initSubviews()
        setupConstraints()
    }

    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: private
    private func initSubviews() {
        pageTitleLabel = UILabel()
        pageTitleLabel.font = UIFont(name: "Avenir-Light", size: 20)
        pageTitleLabel.textColor = UIColor.whiteColor()
        pageTitleLabel.text = "Timeline"
        searchButton = UIButton(type: .Custom)
        searchButton.setImage(UIImage(named: "search-icon"), forState: .Normal)
        searchButton.imageView?.contentMode = .ScaleAspectFill
        timelineButton = UIButton(type: .Custom)
        timelineButton.setImage(UIImage(named: "timeline-selected"), forState: .Normal)
        timelineButton.imageView?.contentMode = .ScaleAspectFit
        timelineButton.imageEdgeInsets = UIEdgeInsetsMake(5, 0, 3, 0)
        chatButton = UIButton(type: .Custom)
        chatButton.setImage(UIImage(named: "chat-normal"), forState: .Normal)
        chatButton.imageView?.contentMode = .ScaleAspectFit
        chatButton.imageEdgeInsets = UIEdgeInsetsMake(5, 0, 3, 0)
        contactsButton = UIButton(type: .Custom)
        contactsButton.setImage(UIImage(named: "contact-normal"), forState: .Normal)
        contactsButton.imageView?.contentMode = .ScaleAspectFit
        contactsButton.imageEdgeInsets = UIEdgeInsetsMake(5, 0, 3, 0)
        meButton = UIButton(type: .Custom)
        meButton.setImage(UIImage(named: "me-normal"), forState: .Normal)
        meButton.imageView?.contentMode = .ScaleAspectFit
        meButton.imageEdgeInsets = UIEdgeInsetsMake(5, 0, 3, 0)
        gradientBackground = CAGradientLayer()
        gradientBackground.colors = [UIColor(rgba: "#BBC1CC").CGColor, UIColor(rgba: "#010B21").CGColor]
        gradientBackground.frame = bounds

        layer.addSublayer(gradientBackground)
        addSubview(pageTitleLabel)
        addSubview(searchButton)
        addSubview(timelineButton)
        addSubview(chatButton)
        addSubview(contactsButton)
        addSubview(meButton)
    }

    private func setupConstraints() {
        let pageButtonWidth = width / 4
        let pageButtonHeight = (openHeight - indicateBarHeight) / 2
        let searchButtonHeight = pageButtonHeight / 2
        let searchButtonWidth = searchButtonHeight * 0.8
        pageTitleLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self)
            make.left.equalTo(self).offset(20.0)
            make.bottom.equalTo(timelineButton.snp_top)
        }
        searchButton.snp_makeConstraints { (make) in
            make.centerX.equalTo(meButton)
            make.centerY.equalTo(pageTitleLabel)
            make.height.equalTo(searchButtonHeight)
            make.width.equalTo(searchButtonWidth)
        }
        timelineButton.snp_makeConstraints { (make) in
            make.bottom.equalTo(self).offset(-indicateBarHeight)
            make.left.equalTo(self)
            make.height.equalTo(pageButtonHeight)
            make.width.equalTo(pageButtonWidth)
        }
        chatButton.snp_makeConstraints { (make) in
            make.bottom.equalTo(self).offset(-indicateBarHeight)
            make.left.equalTo(timelineButton.snp_right)
            make.height.equalTo(pageButtonHeight)
            make.width.equalTo(pageButtonWidth)
        }
        contactsButton.snp_makeConstraints { (make) in
            make.bottom.equalTo(self).offset(-indicateBarHeight)
            make.left.equalTo(chatButton.snp_right)
            make.height.equalTo(pageButtonHeight)
            make.width.equalTo(pageButtonWidth)
        }
        meButton.snp_makeConstraints { (make) in
            make.bottom.equalTo(self).offset(-indicateBarHeight)
            make.left.equalTo(contactsButton.snp_right)
            make.height.equalTo(pageButtonHeight)
            make.width.equalTo(pageButtonWidth)
        }
    }
}
