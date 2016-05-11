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
protocol FBPageHeaderViewDelegate: class {
    func searchTextDidChange(headerView view: FBPageHeaderView, searchText: String)
    func searchTextDidReturn(headerView view: FBPageHeaderView, searchText: String)
    func willShowSearchTextField(headerView view: FBPageHeaderView)
    func timelineButtonPressed(headerView view: FBPageHeaderView)
    func chatButtonPressed(headerView view: FBPageHeaderView)
    func contactButtonPressed(headerView view: FBPageHeaderView)
    func meButtonPressed(headerView view: FBPageHeaderView)
}

class FBPageHeaderView: UIView, UITextFieldDelegate {
    weak var delegate: FBPageHeaderViewDelegate?
    var pageTitleLabel: UILabel!
    var searchButton: UIButton!
    var timelineButton: UIButton!
    var chatButton: UIButton!
    var contactButton: UIButton!
    var meButton: UIButton!
    var indicateBar: UIView!
    var gradientBackground: CAGradientLayer!

    //search stuffs
    var searchToggled = false
    var searchTextField: UITextField!
    var searchLayer: CALayer!

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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(textFieldDidChange), name: UITextFieldTextDidChangeNotification, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        delegate?.searchTextDidReturn(headerView: self, searchText: searchTextField.text ?? "")
        return true
    }

    // MARK: private
    func textFieldDidChange(textField: UITextField) {
        delegate?.searchTextDidChange(headerView: self, searchText: searchTextField.text ?? "")
    }

    private func initSubviews() {
        pageTitleLabel = UILabel()
        pageTitleLabel.font = UIFont(name: "Avenir-Light", size: 20)
        pageTitleLabel.textColor = UIColor.whiteColor()
        pageTitleLabel.text = "Timeline"
        searchButton = UIButton(type: .Custom)
        searchButton.addTarget(self, action: #selector(searchButtonPressed), forControlEvents: .TouchUpInside)
        searchButton.setImage(UIImage(named: "search-icon"), forState: .Normal)
        searchButton.imageView?.contentMode = .ScaleAspectFill
        timelineButton = UIButton(type: .Custom)
        timelineButton.addTarget(self, action: #selector(timelineButtonPressed), forControlEvents: .TouchUpInside)
        timelineButton.setImage(UIImage(named: "timeline-selected"), forState: .Normal)
        timelineButton.imageView?.contentMode = .ScaleAspectFit
        timelineButton.imageEdgeInsets = UIEdgeInsetsMake(5, 0, 3, 0)
        chatButton = UIButton(type: .Custom)
        chatButton.addTarget(self, action: #selector(chatButtonPressed), forControlEvents: .TouchUpInside)
        chatButton.setImage(UIImage(named: "chat-normal"), forState: .Normal)
        chatButton.imageView?.contentMode = .ScaleAspectFit
        chatButton.imageEdgeInsets = UIEdgeInsetsMake(5, 0, 3, 0)
        contactButton = UIButton(type: .Custom)
        contactButton.addTarget(self, action: #selector(contactButtonPressed), forControlEvents: .TouchUpInside)
        contactButton.setImage(UIImage(named: "contact-normal"), forState: .Normal)
        contactButton.imageView?.contentMode = .ScaleAspectFit
        contactButton.imageEdgeInsets = UIEdgeInsetsMake(5, 0, 3, 0)
        meButton = UIButton(type: .Custom)
        meButton.addTarget(self, action: #selector(meButtonPressed), forControlEvents: .TouchUpInside)
        meButton.setImage(UIImage(named: "me-normal"), forState: .Normal)
        meButton.imageView?.contentMode = .ScaleAspectFit
        meButton.imageEdgeInsets = UIEdgeInsetsMake(5, 0, 3, 0)
        gradientBackground = CAGradientLayer()
        gradientBackground.colors = [UIColor(rgba: "#BBC1CC").CGColor, UIColor(rgba: "#010B21").CGColor]
        gradientBackground.frame = bounds

        searchTextField = UITextField()
        searchTextField.delegate = self
        searchTextField.font = UIFont(name: "Avenir-Light", size: 14)
        searchTextField.placeholder = "Search for people"
        searchTextField.leftView = UIView(frame: CGRectMake(0, 0, 10, 0))
        searchTextField.leftViewMode = .Always

        searchLayer = CALayer()
        searchLayer.cornerRadius = 4.0
        searchLayer.backgroundColor = UIColor.whiteColor().CGColor
        searchLayer.frame = CGRectMake(0, 0, 0, 0.32 * openHeight)
        searchTextField.layer.addSublayer(searchLayer)

        layer.addSublayer(gradientBackground)
        addSubview(pageTitleLabel)
        addSubview(searchButton)
        addSubview(searchTextField)
        addSubview(timelineButton)
        addSubview(chatButton)
        addSubview(contactButton)
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
        searchTextField.snp_makeConstraints { (make) in
            make.centerY.equalTo(searchButton)
            make.right.equalTo(searchButton.snp_left).offset(-5.0)
            make.height.equalTo(0.32 * openHeight)
            make.width.equalTo(0)
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
        contactButton.snp_makeConstraints { (make) in
            make.bottom.equalTo(self).offset(-indicateBarHeight)
            make.left.equalTo(chatButton.snp_right)
            make.height.equalTo(pageButtonHeight)
            make.width.equalTo(pageButtonWidth)
        }
        meButton.snp_makeConstraints { (make) in
            make.bottom.equalTo(self).offset(-indicateBarHeight)
            make.left.equalTo(contactButton.snp_right)
            make.height.equalTo(pageButtonHeight)
            make.width.equalTo(pageButtonWidth)
        }
    }

    private func toggleSearchStuffs() {
        if searchToggled {
            UIView .animateWithDuration(0.25, animations: {
                self.pageTitleLabel.alpha = 1.0
                self.searchTextField.snp_remakeConstraints { (make) in
                    make.centerY.equalTo(self.searchButton)
                    make.right.equalTo(self.searchButton.snp_left).offset(-5.0)
                    make.height.equalTo(0.32 * self.openHeight)
                    make.width.equalTo(0)
                }
                self.layoutIfNeeded()
                }, completion: { (finished) in
                    self.searchLayer.frame = self.searchTextField.bounds
            })
        } else {
            UIView.animateWithDuration(0.25, animations: {
                self.pageTitleLabel.alpha = 0.0
                self.searchTextField.snp_remakeConstraints { (make) in
                    make.centerY.equalTo(self.searchButton)
                    make.right.equalTo(self.searchButton.snp_left).offset(-5.0)
                    make.height.equalTo(0.32 * self.openHeight)
                    make.left.equalTo(self).offset(10)
                }
                self.layoutIfNeeded()
                }, completion: { (finished) in
                    self.searchLayer.frame = self.searchTextField.bounds
                    self.searchTextField.becomeFirstResponder()
            })
        }
        searchToggled = !searchToggled
    }

    // MARK: actions
    func searchButtonPressed(sender: UIButton) {
        toggleSearchStuffs()
        delegate?.willShowSearchTextField(headerView: self)
    }

    func timelineButtonPressed(sender: UIButton) {
        delegate?.timelineButtonPressed(headerView: self)
    }

    func chatButtonPressed(sender: UIButton) {
        delegate?.chatButtonPressed(headerView: self)
    }

    func contactButtonPressed(sender: UIButton) {
        delegate?.contactButtonPressed(headerView: self)
    }

    func meButtonPressed(sender: UIButton) {
        delegate?.meButtonPressed(headerView: self)
    }
}
