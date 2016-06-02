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
import Material

private let actionGroupButtonHeightWidthProportion: CGFloat = 7 / 10

protocol FBTimelineCellDelegate: class {
    func fbTimelineCellDidPressRepostButton(cell: FBTimelineCell)
    func fbTimelineCellDidPressLikeButton(cell: FBTimelineCell)
    func fbTimelineCellDidPressCommentButton(cell: FBTimelineCell)
}

class FBTimelineCell: UITableViewCell {
    var timeline: FBTimeline!
    var popButtonGroupToggled = false
    var indexPath: NSIndexPath = NSIndexPath(forRow: -1, inSection: 0)
    weak var delegate: FBTimelineCellDelegate?

    // MARK: public
    func configWithTimeline(timeline: FBTimeline, indexPath: NSIndexPath) {
        setupButtonTargets()
        self.timeline = timeline
        let avatarURL = NSURL(string: timeline.user?.avatarURL ?? "")
        likeButton.setImage(UIImage(named: timeline.liked.contains(FBUserManager.sharedManager().user) ?"liked": "like"), forState: .Normal)
        if self.indexPath == indexPath {
            mainTimelineView.config(avatarURL: avatarURL, nickname: timeline.user?.nickname, text: timeline.text, imageURLs: timeline.images)
        } else {
            mainTimelineView.config(nickname: timeline.user?.nickname, text: timeline.text, imageURLs: timeline.images)
        }
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
        popButtonGroupToggled = false
        mainTimelineView.clear()
        repostTimelineView.clear()
        repostTimelineView.snp_remakeConstraints { (make) in
            make.top.equalTo(mainTimelineView.snp_bottom)
            make.height.equalTo(0)
        }
        removeButtonTargets()
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        popButtonGroup.popBack()
    }

    // MARK: action
    func actionButtonPressed(sender: UIButton) {
        if popButtonGroupToggled {
            popButtonGroup.popBack()
        } else {
            pop(sender)
            popButtonGroup.popLeftFromPoint(CGPointMake(sender.frame.origin.x - 3.0, sender.center.y))
        }
        popButtonGroupToggled = !popButtonGroupToggled
    }

    func repostButtonPressed(sender: UIButton) {
        pop(sender.imageView)
        delegate?.fbTimelineCellDidPressRepostButton(self)
    }

    func likeButtonPressed(sender: UIButton) {
        pop(sender.imageView)
        delegate?.fbTimelineCellDidPressLikeButton(self)
        let myInfo = FBUserManager.sharedManager().user
        if timeline.liked.contains(myInfo) {
            //timeline.liked.removeAtIndex(timeline.liked.indexOf(myInfo)!)
            sender.setImage(UIImage(named: "liked"), forState: .Normal)
        } else {
            //timeline.liked.append(myInfo)
            sender.setImage(UIImage(named: "like"), forState: .Normal)
        }
    }

    func commentButtonPressed(sender: UIButton) {
        pop(sender.imageView)
        delegate?.fbTimelineCellDidPressCommentButton(self)
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
            make.width.equalTo(25.0)
            make.height.equalTo(actionButton.snp_width).multipliedBy(actionGroupButtonHeightWidthProportion)
        }
    }

    private var repostButton: UIButton!
    private var likeButton: UIButton!
    private var commentButton: UIButton!

    private func popButtonGroupButtons() -> [UIButton] {
        func button(title: String) -> UIButton {
            let btn = UIButton()
            btn.setTitle(title, forState: .Normal)
            btn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            btn.titleLabel?.font = UIFont.fb_defaultFontOfSize(12.0)
            return btn
        }

        repostButton = button("repost")
        repostButton.setImage(UIImage(named: "repost"), forState: .Normal)

        likeButton = button("like")
        likeButton.setImage(UIImage(named: "like"), forState: .Normal)

        commentButton = button("comment")
        commentButton.setImage(UIImage(named: "comment"), forState: .Normal)

        return [repostButton, likeButton, commentButton]
    }

    // MARK: - privates
    private func setupButtonTargets() {
        repostButton.addTarget(self, action: #selector(repostButtonPressed), forControlEvents: .TouchUpInside)
        likeButton.addTarget(self, action: #selector(likeButtonPressed), forControlEvents: .TouchUpInside)
        commentButton.addTarget(self, action: #selector(commentButtonPressed), forControlEvents: .TouchUpInside)
    }

    private func removeButtonTargets() {
        repostButton.removeTarget(self, action: #selector(repostButtonPressed), forControlEvents: .TouchUpInside)
        likeButton.removeTarget(self, action: #selector(likeButtonPressed), forControlEvents: .TouchUpInside)
        commentButton.removeTarget(self, action: #selector(commentButtonPressed), forControlEvents: .TouchUpInside)
    }

    private func pop(view: UIView?) {
        let anim = CAKeyframeAnimation(keyPath: "transform")
        anim.duration = 0.4
        anim.values = [
            NSValue(CATransform3D: CATransform3DMakeScale(2.0, 2.0, 1.0)),
            NSValue(CATransform3D: CATransform3DMakeScale(1.5, 1.5, 1.0)),
            NSValue(CATransform3D: CATransform3DMakeScale(1.8, 1.8, 1.0)),
            NSValue(CATransform3D: CATransform3DIdentity)
        ]
        view?.layer.addAnimation(anim, forKey: nil)
    }
}