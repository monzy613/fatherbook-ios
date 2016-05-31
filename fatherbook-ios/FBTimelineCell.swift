//
//  FBTimelineCell.swift
//  fatherbook-ios
//
//  Created by Monzy Zhang on 5/28/16.
//  Copyright © 2016 MonzyZhang. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage
import MZPopView

class FBTimelineCell: UITableViewCell {
    var timeline: FBTimeline!
    var popButtonGroupToggled = false

    // MARK: config
    func configWithTimeline(timeline: FBTimeline) {
        self.timeline = timeline
        let avatarURL = NSURL(string: timeline.user?.avatarURL ?? "")
        mainTimelineView.config(avatarURL: avatarURL, nickname: timeline.user?.nickname, text: timeline.text, imageURLs: timeline.images)
        if let repostedTimeline = timeline.repostTimeline {
            if !timeline.isRepost {
                return
            }
            repostTimelineView.config(nickname: repostedTimeline.user?.nickname, text: repostedTimeline.text, imageURLs: repostedTimeline.images)
            repostTimelineView.snp_remakeConstraints { (make) in
                make.top.equalTo(mainTimelineView.snp_bottom)
                make.left.right.equalTo(mainTimelineView)
            }
        }
    }

    // MARK: lazy properties
    lazy var mainTimelineView: FBTimelineView = {
        let view = FBTimelineView(frame: CGRectZero, isRepost: false)
        return view
    }()

    lazy var repostTimelineView: FBTimelineView = {
        let view = FBTimelineView(frame: CGRectZero, isRepost: true)
        return view
    }()

    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.grayColor()
        label.font = UIFont.fb_defaultFontOfSize(10)
        return label;
    }()

    lazy var actionButton: UIButton = {
        let button = UIButton(type: .System)
        button.setBackgroundImage(UIImage(named: "timeline-action-group"), forState: .Normal)
        button.addTarget(self, action: #selector(actionButtonPressed), forControlEvents: .TouchUpInside)
        return button
    }()

    lazy var popButtonGroup: MZPopButtonGroup = {
        let buttonGroup = MZPopButtonGroup()

        buttonGroup.buttons = self.popButtonGroupButtons()
        buttonGroup.color = UIColor.fb_darkColor()
        buttonGroup.separateLineColor = UIColor.fb_lightColor()
        return buttonGroup
    }()

    // MARK: - life cycle
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .None
        contentView.addSubview(mainTimelineView)
        contentView.addSubview(repostTimelineView)
        contentView.addSubview(timeLabel)
        contentView.addSubview(actionButton)
        contentView.addSubview(popButtonGroup)
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        popButtonGroup.popBack()
        mainTimelineView.clear()
        repostTimelineView.clear()
        repostTimelineView.snp_remakeConstraints { (make) in
            make.top.equalTo(mainTimelineView.snp_bottom)
            make.height.equalTo(0)
        }
    }

    // MARK: action
    func actionButtonPressed(sender: UIButton) {
        if popButtonGroupToggled {
            popButtonGroup.popBack()
        } else {
            popButtonGroup.popLeftFromPoint(CGPointMake(sender.frame.origin.x - 3.0, sender.center.y))
        }
        popButtonGroupToggled = !popButtonGroupToggled
    }

    func likeButtonPressed(sender: UIButton) {

    }

    func commentButtonPressed(sender: UIButton) {

    }

    // MARK: private
    private func setupConstraints() {
        mainTimelineView.snp_makeConstraints { (make) in
            make.top.left.right.equalTo(contentView)
        }

        repostTimelineView.snp_makeConstraints { (make) in
            make.top.equalTo(mainTimelineView.snp_bottom)
            make.height.equalTo(0)
        }

        actionButton.snp_makeConstraints { (make) in
            make.top.equalTo(repostTimelineView.snp_bottom).offset(10.0)
            make.right.bottom.equalTo(contentView).inset(10.0)
            make.width.equalTo(20.0)
            make.height.equalTo(14.0)
        }
    }

    private func popButtonGroupButtons() -> [UIButton] {
        let likeButton = UIButton(type: .System)
        likeButton.addTarget(self, action: #selector(likeButtonPressed), forControlEvents: .TouchUpInside)
        likeButton.setTitle("like", forState: .Normal)
        likeButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        likeButton.setImage(UIImage(named: "like"), forState: .Normal)
        likeButton.tintColor = UIColor.whiteColor()
        likeButton.titleLabel?.font = UIFont.fb_defaultFontOfSize(12.0)

        let commentButton = UIButton(type: .System)
        commentButton.addTarget(self, action: #selector(commentButtonPressed), forControlEvents: .TouchUpInside)
        commentButton.setTitle("comment", forState: .Normal)
        commentButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        commentButton.setImage(UIImage(named: "comment"), forState: .Normal)
        commentButton.tintColor = UIColor.whiteColor()
        commentButton.titleLabel?.font = UIFont.fb_defaultFontOfSize(12.0)
        return [likeButton, commentButton]
    }
}