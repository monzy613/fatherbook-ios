//
//  FBButtonTableViewCell.swift
//  fatherbook-ios
//
//  Created by Monzy Zhang on 5/16/16.
//  Copyright © 2016 MonzyZhang. All rights reserved.
//

import UIKit
import SnapKit
import MZGoogleStyleButton

class FBButtonTableViewCell: UITableViewCell {
    lazy var button: MZGoogleStyleButton = {
        let _button = MZGoogleStyleButton()
        _button.layer.cornerRadius = 4.0
        _button.titleLabel?.font = UIFont.fb_defaultFontOfSize(14)
        _button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        return _button
    }()
    var handler: ((FBButtonTableViewCell) -> ())?

    // MARK: - init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .None
        backgroundColor = UIColor.clearColor()
        contentView.addSubview(button)
        button.addTarget(self, action: #selector(buttonPressed), forControlEvents: .TouchUpInside)
        button.snp_makeConstraints { (make) in
            make.center.equalTo(contentView)
            make.height.equalTo(self)
            make.left.right.equalTo(contentView).inset(18.0)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - action
    @objc private func buttonPressed(sender: UIButton) {
        self.handler?(self)
    }

    // MARK: config
    func configWithHandler(handler: ((FBButtonTableViewCell) -> ())?) {
        self.handler = handler
    }
}
