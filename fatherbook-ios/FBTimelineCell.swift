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

class FBTimelineCell: UITableViewCell {
    var timeline: FBTimeline!

    // MARK: config
    func configWithTimeline(timeline: FBTimeline) {
        self.timeline = timeline
        let avatarURL = NSURL(string: timeline.user?.avatarURL ?? "")
        mainTimelineView.config(avatarURL: avatarURL, nickname: timeline.user?.nickname, text: timeline.text, imageURLs: timeline.images)
        if (timeline.isRepost) {
            //remake constraints with repost
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
        return button
    }()

    // MARK: - life cycle
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(mainTimelineView)
        contentView.addSubview(timeLabel)
        contentView.addSubview(actionButton)
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        mainTimelineView.clear()
        if timeline != nil && timeline.isRepost {
            repostTimelineView.clear()
        }
    }

    // MARK: private
    private func setupConstraints() {
        mainTimelineView.snp_makeConstraints { (make) in
            make.top.left.right.equalTo(contentView)
        }

        actionButton.snp_makeConstraints { (make) in
            make.top.equalTo(mainTimelineView.snp_bottom).offset(10.0)
            make.right.bottom.equalTo(contentView).inset(10.0)
            make.width.equalTo(20.0)
            make.height.equalTo(14.0)
        }
    }
}