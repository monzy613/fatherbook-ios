//
//  FBUserTableViewCell.swift
//  fatherbook-ios
//
//  Created by Monzy Zhang on 5/12/16.
//  Copyright © 2016 MonzyZhang. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage
import MZGoogleStyleButton

class FBUserTableViewCell: UITableViewCell {
    
    // MARK: public properties
    var actionButtonHandler: ((FBUserTableViewCell) -> ())?
    var avatarTouchHandler: ((FBUserTableViewCell) -> ())?

    // MARK: private properties
    private lazy var avatarImageView: UIImageView = {
        let _avatarImageView = UIImageView()
        _avatarImageView.clipsToBounds = true
        _avatarImageView.layer.cornerRadius = 4.0
        _avatarImageView.contentMode = .ScaleAspectFill
        _avatarImageView.userInteractionEnabled = true
        _avatarImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapHandler)))
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let image = UIImage(named: "default-avatar")
            dispatch_async(dispatch_get_main_queue(), {
                _avatarImageView.image = image
            })
        }
        return _avatarImageView
    }()

    private lazy var nicknameLabel: UILabel = {
        let _nicknameLabel = UILabel()
        _nicknameLabel.font = UIFont.fb_defaultFontOfSize(14)
        return _nicknameLabel
    }()

    private lazy var accountLabel: UILabel = {
        let _accountLabel = UILabel()
        _accountLabel.textColor = UIColor.grayColor()
        _accountLabel.font = UIFont.fb_defaultFontOfSize(14)
        return _accountLabel
    }()

    private lazy var actionButton: MZGoogleStyleButton = {
        let _actionButton = MZGoogleStyleButton()
        _actionButton.addTarget(self, action: #selector(actionButtonPressed), forControlEvents: .TouchUpInside)
        _actionButton.clipsToBounds = true
        _actionButton.layer.cornerRadius = 4.0
        return _actionButton
    }()


    // MARK: init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubviews()
    }

    func configureWith(userInfo userInfo: FBUserInfo) {
        nicknameLabel.text = userInfo.nickname ?? userInfo.account ?? "nil"
        accountLabel.text = "soa ID: \(userInfo.account ?? "nil")"
        setStateWithRelation(userInfo.relation)
    }

    func configureContactCellWith(userInfo userInfo: FBUserInfo) {
        nicknameLabel.text = userInfo.nickname ?? userInfo.account ?? "nil"
        accountLabel.text = "soa ID: \(userInfo.account ?? "nil")"
        avatarImageView.sd_setImageWithURL(NSURL(string: userInfo.avatarURL), placeholderImage: UIImage(named: "default-avatar"))
        actionButton.removeFromSuperview()
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

    // MARK: public
    func setStateWithRelation(relation: FBUserRelation?) {
        guard let relation = relation else {
            return
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            var image: UIImage!
            switch relation {
            case .Follow:
                image = UIImage(named: "follow")
            case .Followed:
                image = UIImage(named: "followed")
            case .TwoWayFollowed:
                image = UIImage(named: "two-way-followed")
            case .Me:
                image = nil
                self.actionButton.enabled = false
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.actionButton.setBackgroundImage(image, forState: .Normal)
            })
        }
    }

    // MARK: action
    @objc private func actionButtonPressed(sender: UIButton) {
        actionButtonHandler?(self)
        //delegate?.actionButtonPressedInCell!(self)
    }

    @objc private func tapHandler(tap: UITapGestureRecognizer) {
        avatarTouchHandler?(self)
        //delegate?.avatarTouched!(self)
    }

    // MARK: private
    private func initSubviews() {
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
