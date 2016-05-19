//
//  FBLeftIconTitleTableViewCell.swift
//  fatherbook-ios
//
//  Created by Monzy Zhang on 5/19/16.
//  Copyright © 2016 MonzyZhang. All rights reserved.
//

import UIKit
import SnapKit

class FBLeftIconTitleTableViewCell: UITableViewCell {
    private lazy var icon: UIImageView = {
        let _icon = UIImageView()
        _icon.contentMode = .ScaleAspectFit
        return _icon
    }()
    private lazy var label: UILabel = {
        let _label = UILabel()
        _label.font = UIFont.fb_defaultFontOfSize(14)
        _label.textColor = UIColor.fb_darkColor()
        return _label
    }()

    // MARK: init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(icon)
        contentView.addSubview(label)
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: public
    func config(withImage image: UIImage?, title: String?) {
        icon.image = image
        label.text = title
    }

    // MARK: private
    private func setupConstraints() {
        icon.snp_makeConstraints { (make) in
            make.left.top.bottom.equalTo(contentView).inset(10)
            make.width.equalTo(icon.snp_height)
        }
        label.snp_makeConstraints { (make) in
            make.left.equalTo(icon.snp_right).offset(10)
            make.top.bottom.equalTo(contentView)
        }
    }
}
