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

class FBTextTimelineView: MaterialView, UITextViewDelegate {
    weak var editorDelegate: FBTextTimelineViewDelegate?
    lazy var textView: UITextView = {
        let _textView = UITextView()
        _textView.font = UIFont.fb_defaultFontOfSize(14)
        _textView.textColor = UIColor.blackColor()
        _textView.delegate = self
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

    // MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(textView)
        addSubview(countLabel)
        addSubview(cancelButton)
        addSubview(sendButton)
        setupView()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - action
    @objc private func sendButtonPressed(sender: UIButton) {
        editorDelegate?.sendButtonPressed(self)
    }

    @objc private func cancelButtonPressed(sender: UIButton) {
        editorDelegate?.cancelButtonPressed(self)
    }

    // MARK: delegate
    // MARK: UITextViewDelegate
    func textViewDidChange(textView: UITextView) {
        countLabel.text = "\(maxTextLength - textView.text.characters.count)"
    }

    // MARK: - private
    private func setupView() {
        shadowOpacity = 1.0
        shadowOffset = CGSizeMake(0.5, 0.5)
        backgroundColor = UIColor.whiteColor()
    }

    private func setupConstraints() {
        textView.snp_makeConstraints { (make) in
            make.left.top.right.equalTo(self).inset(10.0)
            make.bottom.equalTo(cancelButton.snp_top).offset(-5.0)
        }
        countLabel.snp_makeConstraints { (make) in
            make.bottom.right.equalTo(textView)
        }
        sendButton.snp_makeConstraints { (make) in
            make.right.bottom.equalTo(self).inset(5.0)
            make.left.equalTo(cancelButton.snp_right).offset(10.0)
            make.width.equalTo(sendButton.snp_height).multipliedBy(4.0)
        }
        cancelButton.snp_makeConstraints { (make) in
            make.left.bottom.equalTo(self).inset(5.0)
            make.width.height.equalTo(sendButton)
        }
    }
}
