//
//  FBTextViewTableViewCell.swift
//  fatherbook-ios
//
//  Created by Monzy Zhang on 6/5/16.
//  Copyright © 2016 MonzyZhang. All rights reserved.
//

import SnapKit
import Material

class FBTextViewTableViewCell: UITableViewCell {
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
        return _textView
    }()

    // MARK: - init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(textView)
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - private
    func setupConstraints() {
        textView.snp_makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
    }
}