//
//  FBTextViewTableViewCell.swift
//  fatherbook-ios
//
//  Created by Monzy Zhang on 6/5/16.
//  Copyright © 2016 MonzyZhang. All rights reserved.
//

import SnapKit
import Material

private let maxTextLength = 140

class FBTextViewTableViewCell: UITableViewCell, UITextViewDelegate {
    lazy var textView: TextView = {
        let _textView = TextView()
        _textView.clipsToBounds = true
        _textView.font = UIFont.fb_defaultFontOfSize(14)
        _textView.textColor = UIColor.blackColor()
        let placeHolderLabel = UILabel()
        placeHolderLabel.text = "分享新鲜事.."
        placeHolderLabel.font = UIFont.fb_defaultFontOfSize(14)
        placeHolderLabel.textColor = UIColor.fb_lightGrayColor()
        _textView.placeholderLabel = placeHolderLabel
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

    // MARK: - init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(textView)
        contentView.addSubview(countLabel)
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - private
    func setupConstraints() {
        textView.snp_makeConstraints { (make) in
            make.edges.equalTo(contentView).inset(3.0)
        }
        countLabel.snp_makeConstraints { (make) in
            make.bottom.right.equalTo(textView)
        }
    }
}