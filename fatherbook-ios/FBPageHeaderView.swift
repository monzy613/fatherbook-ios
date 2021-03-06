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
    func searchTextDidChange(headerView headerView: FBPageHeaderView, searchText: String)
    func searchTextDidReturn(headerView headerView: FBPageHeaderView, searchText: String)
    func willShowSearchTextField(headerView headerView: FBPageHeaderView)
    func willDismissSearchTextField(headerView headerView: FBPageHeaderView)
    func timelineButtonPressed(headerView headerView: FBPageHeaderView)
    func chatButtonPressed(headerView headerView: FBPageHeaderView)
    func contactButtonPressed(headerView headerView: FBPageHeaderView)
    func meButtonPressed(headerView headerView: FBPageHeaderView)
}

protocol FBPageHeaderViewDataSource: class {
    func headerView(headerView: FBPageHeaderView, titleAtIndex index: Int) -> String
}

class FBPageHeaderView: UIView, UITextFieldDelegate {
    weak var delegate: FBPageHeaderViewDelegate?
    weak var dataSource: FBPageHeaderViewDataSource?

    var pageTitleLabel: UILabel!
    var loadingIndicator: UIActivityIndicatorView!

    var timelineButton: UIButton!
    var chatButton: UIButton!
    var contactButton: UIButton!
    var meButton: UIButton!

    var searchButton: UIButton!
    var indicateBar: CALayer!
    var searchAnimating = false

    //search stuffs
    var searchToggled = false
    var searchTextField: UITextField!

    //open clode
    var isOpen = true
    var width: CGFloat = 0
    var closeHeight: CGFloat {
        return timelineButton.frame.origin.y - 3.0
    }
    var tabButtonHeight: CGFloat {
        return CGRectGetHeight(timelineButton.bounds)
    }
    var openHeight: CGFloat = 0
    var currentIndex = 0


    // MARK: init
    convenience init(width: CGFloat, openHeight: CGFloat) {
        self.init(frame: CGRectMake(0, 0, width, openHeight + statusBarHeight))
        self.width = width
        self.openHeight = openHeight + statusBarHeight
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

    // MARK: public
    func startLoading() {
        pageTitleLabel.text = "Loading..."
        loadingIndicator.startAnimating()
    }

    func endLoading() {
        loadingIndicator.stopAnimating()
        pageTitleLabel.text = dataSource?.headerView(self, titleAtIndex: currentIndex) ?? "SOA"
    }

    func endSearch() {
        searchButtonPressed(searchButton)
    }

    func open(canOpen: (() -> ())?) {
        if isOpen {
            return
        }
        self.isOpen = true
        UIView.animateWithDuration(0.25) {
            canOpen?()
            self.frame = CGRectMake(0, 0, self.width, self.openHeight)
            self.pageTitleLabel.alpha = 1.0
            self.searchButton.alpha = 1.0
        }
    }

    func close(canClose: (() -> ())?) {
        if !isOpen {
            return
        }
        self.isOpen = false
        UIView.animateWithDuration(0.25) {
            canClose?()
            self.frame = CGRectMake(0, -self.openHeight + statusBarHeight + CGRectGetHeight(self.timelineButton.bounds), self.width, self.openHeight)
            self.pageTitleLabel.alpha = 0.0
            self.searchButton.alpha = 0.0
        }
    }

    func moveTo(index index: Int) {
        currentIndex = index
        switch index {
        case 0:
            moveBarToButton(timelineButton)
        case 1:
            moveBarToButton(chatButton)
        case 2:
            moveBarToButton(contactButton)
        case 3:
            moveBarToButton(meButton)
        default:
            break
        }
    }

    func moveTo(leftPercent: CGFloat) {
        var center = indicateBar.position
        center.x = width * lerp(low: 0.0, max: 0.75, val: leftPercent) + CGRectGetWidth(indicateBar.frame) / 2
        indicateBar.position = center
    }

    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        delegate?.searchTextDidReturn(headerView: self, searchText: searchTextField.text ?? "")
        return true
    }

    // MARK: private
    private func moveBarToButton(sender: UIButton) {
        var center = indicateBar.position
        center.x = sender.center.x
        indicateBar.position = center
        setSelected(sender)
    }

    private func lerp<T where T: Comparable>(low low: T, max: T, val: T) -> T {
        var result: T = val
        if val < low {
            result = low
        } else if val > max {
            result = max
        }
        return result
    }

    private func setSelected(sender: UIButton) {
        if !loadingIndicator.isAnimating() {
            pageTitleLabel.text = dataSource?.headerView(self, titleAtIndex: currentIndex) ?? "SOA"
        }
        switch sender {
        case timelineButton:
            timelineButton.setImage(UIImage(named: "timeline-selected"), forState: .Normal)
            chatButton.setImage(UIImage(named: "chat-normal"), forState: .Normal)
            contactButton.setImage(UIImage(named: "contact-normal"), forState: .Normal)
            meButton.setImage(UIImage(named: "me-normal"), forState: .Normal)
        case chatButton:
            timelineButton.setImage(UIImage(named: "timeline-normal"), forState: .Normal)
            chatButton.setImage(UIImage(named: "chat-selected"), forState: .Normal)
            contactButton.setImage(UIImage(named: "contact-normal"), forState: .Normal)
            meButton.setImage(UIImage(named: "me-normal"), forState: .Normal)
        case contactButton:
            timelineButton.setImage(UIImage(named: "timeline-normal"), forState: .Normal)
            chatButton.setImage(UIImage(named: "chat-normal"), forState: .Normal)
            contactButton.setImage(UIImage(named: "contact-selected"), forState: .Normal)
            meButton.setImage(UIImage(named: "me-normal"), forState: .Normal)
        case meButton:
            timelineButton.setImage(UIImage(named: "timeline-normal"), forState: .Normal)
            chatButton.setImage(UIImage(named: "chat-normal"), forState: .Normal)
            contactButton.setImage(UIImage(named: "contact-normal"), forState: .Normal)
            meButton.setImage(UIImage(named: "me-selected"), forState: .Normal)
        default:
            break
        }
    }

    private func initSubviews() {
        backgroundColor = UIColor.fb_darkColor()

        pageTitleLabel = UILabel()
        pageTitleLabel.font = UIFont.fb_defaultFontOfSize(20)
        pageTitleLabel.textColor = UIColor.whiteColor()
        pageTitleLabel.text = "Timeline"

        loadingIndicator = UIActivityIndicatorView()

        searchButton = UIButton(type: .Custom)
        searchButton.addTarget(self, action: #selector(searchButtonPressed), forControlEvents: .TouchUpInside)
        searchButton.setImage(UIImage(named: "search-icon"), forState: .Normal)
        searchButton.imageView?.contentMode = .ScaleAspectFit

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


        searchTextField = UITextField()
        searchTextField.delegate = self
        searchTextField.font = UIFont.fb_defaultFontOfSize(14)
        searchTextField.placeholder = "Search for people"
        searchTextField.leftView = UIView(frame: CGRectMake(0, 0, 10, 0))
        searchTextField.layer.cornerRadius = 4.0
        searchTextField.backgroundColor = UIColor.whiteColor()
        searchTextField.leftViewMode = .Always

        indicateBar = CALayer()
        indicateBar.backgroundColor = UIColor.whiteColor().CGColor
        indicateBar.frame = CGRectMake(0, openHeight - 7, width / 4, 7)

        addSubview(pageTitleLabel)
        addSubview(loadingIndicator)
        addSubview(searchButton)
        addSubview(searchTextField)
        addSubview(timelineButton)
        addSubview(chatButton)
        addSubview(contactButton)
        addSubview(meButton)
        layer.addSublayer(indicateBar)
    }

    private func setupConstraints() {
        let pageButtonHeight = (openHeight - indicateBarHeight) / 2
        let searchButtonHeight = pageButtonHeight / 2
        pageTitleLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self).offset(statusBarHeight)
            make.left.equalTo(self).offset(20.0)
            make.bottom.equalTo(timelineButton.snp_top)
        }
        loadingIndicator.snp_makeConstraints(closure: { (make) in
            make.left.equalTo(pageTitleLabel.snp_right).offset(5.0)
            make.centerY.equalTo(pageTitleLabel)
        })
        searchButton.snp_makeConstraints { (make) in
            make.centerX.equalTo(meButton)
            make.centerY.equalTo(pageTitleLabel)
            make.height.equalTo(searchButtonHeight)
            make.right.equalTo(self)
            make.left.equalTo(meButton).offset(10)
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
            make.left.equalTo(self)
        }
        chatButton.snp_makeConstraints { (make) in
            make.bottom.equalTo(self).offset(-indicateBarHeight)
            make.left.equalTo(timelineButton.snp_right)
            make.height.equalTo(pageButtonHeight)
            make.width.equalTo(timelineButton)
        }
        contactButton.snp_makeConstraints { (make) in
            make.bottom.equalTo(self).offset(-indicateBarHeight)
            make.left.equalTo(chatButton.snp_right)
            make.height.equalTo(pageButtonHeight)
            make.width.equalTo(timelineButton)
        }
        meButton.snp_makeConstraints { (make) in
            make.bottom.equalTo(self).offset(-indicateBarHeight)
            make.left.equalTo(contactButton.snp_right)
            make.height.equalTo(pageButtonHeight)
            make.width.equalTo(timelineButton)
        }
    }

    private func toggleSearchStuffs() {
        searchAnimating = true
        if searchToggled {
            endEditing(true)
            delegate?.willDismissSearchTextField(headerView: self)
            searchTextField.text = ""
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
                    self.searchAnimating = false
            })
        } else {
            delegate?.willShowSearchTextField(headerView: self)
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
                    self.searchAnimating = false
                    self.searchTextField.becomeFirstResponder()
            })
        }
        searchToggled = !searchToggled
    }

    // MARK: actions
    @objc private func searchButtonPressed(sender: UIButton) {
        if searchAnimating {
            return
        }
        toggleSearchStuffs()
    }

    @objc private func timelineButtonPressed(sender: UIButton) {
        delegate?.timelineButtonPressed(headerView: self)
        currentIndex = 0
        moveBarToButton(sender)
    }

    @objc private func chatButtonPressed(sender: UIButton) {
        delegate?.chatButtonPressed(headerView: self)
        currentIndex = 1
        moveBarToButton(sender)
    }

    @objc private func contactButtonPressed(sender: UIButton) {
        delegate?.contactButtonPressed(headerView: self)
        currentIndex = 2
        moveBarToButton(sender)
    }

    @objc private func meButtonPressed(sender: UIButton) {
        delegate?.meButtonPressed(headerView: self)
        currentIndex = 3
        moveBarToButton(sender)
    }

    @objc private func textFieldDidChange(textField: UITextField) {
        delegate?.searchTextDidChange(headerView: self, searchText: searchTextField.text ?? "")
    }
}
