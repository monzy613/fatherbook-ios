//
//  FBTextTimelineView.swift
//  fatherbook-ios
//
//  Created by Monzy Zhang on 5/23/16.
//  Copyright © 2016 MonzyZhang. All rights reserved.
//

import UIKit
import SnapKit
import Material

private let maxTextLength = 140

protocol FBTextTimelineViewDelegate: class {
    func sendButtonPressed(textEditor: FBTextTimelineView)
    func cancelButtonPressed(textEditor: FBTextTimelineView)
}

class FBTextTimelineView: UIView, UITextViewDelegate {
    weak var editorDelegate: FBTextTimelineViewDelegate?
    var widthProportion: CGFloat = 0.747
    var heightProportion: CGFloat = 0.375

    lazy var contentView: MaterialView = {
        let _contentView = MaterialView()
        _contentView.backgroundColor = UIColor.whiteColor()
        return _contentView
    }()

    lazy var textView: TextView = {
        let _textView = TextView()
        _textView.clipsToBounds = true
        _textView.font = UIFont.fb_defaultFontOfSize(14)
        _textView.textColor = UIColor.blackColor()
        _textView.delegate = self
        let placeHolderLabel = UILabel()
        placeHolderLabel.text = "分享新鲜事.."
        placeHolderLabel.font = UIFont.fb_defaultFontOfSize(14)
        placeHolderLabel.textColor = UIColor.fb_lightGrayColor()
        _textView.placeholderLabel = placeHolderLabel
        return _textView
    }()

    lazy var countLabel: UILabel = {
        let _countLabel = UILabel()
        _countLabel.font = UIFont.fb_defaultFontOfSize(14)
        _countLabel.textColor = UIColor.fb_lightColor()
        _countLabel.text = "\(maxTextLength)"
        return _countLabel
    }()

    lazy var sendButton: RaisedButton = {
        let _sendButton = RaisedButton()
        _sendButton.addTarget(self, action: #selector(sendButtonPressed), forControlEvents: .TouchUpInside)
        _sendButton.titleLabel?.font = UIFont.fb_defaultFontOfSize(14)
        _sendButton.backgroundColor = UIColor.fb_darkColor()
        _sendButton.setTitle("发送", forState: .Normal)
        _sendButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        _sendButton.cornerRadius = 4.0
        return _sendButton
    }()

    lazy var cancelButton: RaisedButton = {
        let _cancelButton = RaisedButton()
        _cancelButton.addTarget(self, action: #selector(cancelButtonPressed), forControlEvents: .TouchUpInside)
        _cancelButton.titleLabel?.font = UIFont.fb_defaultFontOfSize(14)
        _cancelButton.backgroundColor = UIColor.fb_lightColor()
        _cancelButton.setTitle("取消", forState: .Normal)
        _cancelButton.setTitleColor(UIColor.fb_darkColor(), forState: .Normal)
        _cancelButton.cornerRadius = 4.0
        return _cancelButton
    }()

    // MARK: init & deinit
    override init(frame: CGRect) {
        super.init(frame: frame)
        if frame == CGRectZero {
            self.frame = UIScreen.mainScreen().bounds
        }
        addSubview(contentView)
        contentView.addSubview(textView)
        contentView.addSubview(countLabel)
        contentView.addSubview(cancelButton)
        contentView.addSubview(sendButton)
        setupView()
        setupConstraints()
        initObservers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: public
    func show() {
        contentView.animate(MaterialAnimation.rotate(rotation: 0))
        UIView.animateWithDuration(0.25) {
            self.contentView.snp_remakeConstraints { (make) in
                make.center.equalTo(self)
                make.width.equalTo(self).multipliedBy(self.widthProportion)
                make.height.equalTo(self).multipliedBy(self.heightProportion)
            }
            self.layoutIfNeeded()
        }
    }

    func dismiss() {
        contentView.animate(MaterialAnimation.rotate(rotation: 0.08))
        UIView.animateWithDuration(0.25, animations: {
            self.contentView.snp_remakeConstraints { (make) in
                make.centerX.equalTo(self)
                make.top.equalTo(self.snp_bottom).offset(20.0)
                make.width.equalTo(self).multipliedBy(self.widthProportion)
                make.height.equalTo(self).multipliedBy(self.heightProportion)
            }
            self.layoutIfNeeded()
            }) { (finished) in
                self.removeFromSuperview()
        }
    }

    // MARK: - action
    @objc private func sendButtonPressed(sender: UIButton) {
        endEditing(true)
        editorDelegate?.sendButtonPressed(self)
    }

    @objc private func cancelButtonPressed(sender: UIButton) {
        endEditing(true)
        editorDelegate?.cancelButtonPressed(self)
    }

    @objc private func spaceTapped(tap: UITapGestureRecognizer) {
        endEditing(true)
        editorDelegate?.cancelButtonPressed(self)
    }

    // MARK: keyboard action handler
    func keyboardWillShow(notification: NSNotification) {
        let keyboardHeight = notification.userInfo![UIKeyboardFrameBeginUserInfoKey]?.CGRectValue().height ?? 0.0
        if keyboardHeight == 0.0 {
            return
        }
        UIView.animateWithDuration(0.25) {
            self.contentView.snp_remakeConstraints { (make) in
                make.centerX.equalTo(self)
                make.bottom.equalTo(self.snp_bottom).offset(-keyboardHeight)
                make.width.equalTo(self).multipliedBy(self.widthProportion)
                make.height.equalTo(self).multipliedBy(self.heightProportion)
            }
            self.layoutIfNeeded()
        }
    }

    func keyboardWillHide(notification: NSNotification) {
        show()
    }

    // MARK: delegate
    // MARK: UITextViewDelegate
    func textViewDidChange(textView: UITextView) {
        if let text = textView.text {
            if text.characters.count > maxTextLength {
                textView.text = text.substringToIndex(text.startIndex.advancedBy(maxTextLength))
            }
            countLabel.text = "\(maxTextLength - textView.text.characters.count)"
        }
    }

    // MARK: - private
    private func setupView() {
        contentView.shadowOpacity = 1.0
        contentView.shadowOffset = CGSizeMake(0.5, 0.5)
        contentView.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI_4))
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(spaceTapped)))
    }

    private func setupConstraints() {
        textView.snp_makeConstraints { (make) in
            make.left.top.right.equalTo(contentView).inset(10.0)
            make.bottom.equalTo(cancelButton.snp_top).offset(-5.0)
        }
        countLabel.snp_makeConstraints { (make) in
            make.bottom.right.equalTo(textView)
        }
        sendButton.snp_makeConstraints { (make) in
            make.right.equalTo(contentView).inset(10.0)
            make.bottom.equalTo(contentView).inset(5.0)
            make.left.equalTo(cancelButton.snp_right).offset(10.0)
            make.width.equalTo(sendButton.snp_height).multipliedBy(4.0)
        }
        cancelButton.snp_makeConstraints { (make) in
            make.left.equalTo(contentView).inset(10.0)
            make.bottom.equalTo(contentView).inset(5.0)
            make.width.height.equalTo(sendButton)
        }
        contentView.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.bottom.equalTo(self.snp_top)
            make.width.equalTo(self).multipliedBy(widthProportion)
            make.height.equalTo(self).multipliedBy(heightProportion)
        }
        layoutIfNeeded()
    }

    private func initObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
    }
}
