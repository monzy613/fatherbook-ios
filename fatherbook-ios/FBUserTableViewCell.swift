//
//  FBUserTableViewCell.swift
//  fatherbook-ios
//
//  Created by Monzy Zhang on 5/12/16.
//  Copyright © 2016 MonzyZhang. All rights reserved.
//

import UIKit
import SnapKit
import MZGoogleStyleButton

class FBUserTableViewCell: UITableViewCell {
    // MARK: init
    var avatarImageView: UIImageView!
    var nicknameLabel: UILabel!
    var accountLabel: UILabel!
    var actionButton: MZGoogleStyleButton!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubviews()
    }

    func configureWith(userInfo userInfo: FBUserInfo) {
        nicknameLabel.text = userInfo.nickname ?? userInfo.account ?? "nil"
        accountLabel.text = "soa ID: \(userInfo.account ?? "nil")"
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            var image: UIImage!
            switch userInfo.relation {
            case .Follow:
                image = UIImage(named: "follow")
            case .Followed:
                image = UIImage(named: "followed")
            case .TwoWayFollowed, .Me:
                image = UIImage(named: "two-way-followed")
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.actionButton.setBackgroundImage(image, forState: .Normal)
            })
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: private
    private func initSubviews() {
        //avatar
        avatarImageView = UIImageView()
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 4.0
        avatarImageView.contentMode = .ScaleAspectFill
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { 
            let image = UIImage(named: "default-avatar")
            dispatch_async(dispatch_get_main_queue(), {
                self.avatarImageView.image = image
            })
        }

        //nicknameLabel
        nicknameLabel = UILabel()
        nicknameLabel.font = UIFont.fb_defaultFontOfSize(14)

        //accountLabel
        accountLabel = UILabel()
        accountLabel.font = UIFont.fb_defaultFontOfSize(14)

        //actionButton
        actionButton = MZGoogleStyleButton()

        contentView.addSubview(avatarImageView)
        contentView.addSubview(nicknameLabel)
        contentView.addSubview(accountLabel)
        contentView.addSubview(actionButton)
        setupConstraints()
    }

    private func setupConstraints() {
        avatarImageView.snp_makeConstraints { (make) in
            make.top.left.bottom.equalTo(contentView).inset(12.0)
            make.width.equalTo(avatarImageView.snp_height)
        }
        nicknameLabel.snp_makeConstraints { (make) in
            make.top.equalTo(avatarImageView)
            make.left.equalTo(avatarImageView.snp_right).offset(10.0)
        }
        accountLabel.snp_makeConstraints { (make) in
            make.top.equalTo(nicknameLabel.snp_bottom).offset(5)
            make.left.equalTo(nicknameLabel)
        }
        actionButton.snp_makeConstraints { (make) in
            make.right.equalTo(contentView).inset(15.0)
            make.centerY.equalTo(contentView)
            make.width.equalTo(avatarImageView)
            make.height.equalTo(actionButton.snp_width).multipliedBy(0.63)
        }
    }

}
