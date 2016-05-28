//
//  FBTimelineView.swift
//  fatherbook-ios
//
//  Created by Monzy Zhang on 5/28/16.
//  Copyright © 2016 MonzyZhang. All rights reserved.
//

import UIKit

class FBTimelineView: UIView {
    private let avatarWidth: CGFloat = 50.0
    var isRepost = false
    var hasImages = false

    // MARK: config
    func config(avatarURL url: NSURL?, nickname: String?, text: String?, imageURLs: [FBTimelineImage]) {
        avatarImageView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "placeholder"))
        nicknameLabel.text = nickname
        timelineTextLabel.text = text
        switch imageURLs.count {
        case 0:
            return
        case 1:
            //imageView
            break
        default:
            //imageCollectionView
            break
        }
    }

    // MARK: init
    init(frame: CGRect, isRepost _isRepost: Bool) {
        super.init(frame: frame)
        isRepost = _isRepost
        if !isRepost {
            addSubview(avatarImageView)
        }
        addSubview(nicknameLabel)
        addSubview(timelineTextLabel)
        addSubview(imagesCollectionView)
        addSubview(imageView)
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: private
    func setupConstraints() {
        if !isRepost {
            avatarImageView.snp_makeConstraints(closure: { (make) in
                make.left.top.equalTo(self).offset(10.0)
                make.height.width.equalTo(avatarWidth)
            })
        }
        nicknameLabel.snp_makeConstraints { (make) in
            if !isRepost {
                make.left.equalTo(avatarImageView.snp_right).offset(10.0)
            } else {
                make.left.equalTo(self).offset(10.0)
            }
            make.top.equalTo(self).offset(10.0)
        }
        timelineTextLabel.snp_makeConstraints { (make) in
            make.top.equalTo(nicknameLabel.snp_bottom).offset(avatarWidth)
            make.left.right.equalTo(self).inset(10.0)
        }
        imagesCollectionView.snp_makeConstraints { (make) in
            make.top.equalTo(timelineTextLabel.snp_bottom)
            make.left.right.bottom.equalTo(imageView.snp_top)
        }
        imageView.snp_makeConstraints { (make) in
            make.top.equalTo(imagesCollectionView.snp_bottom)
            make.left.right.bottom.equalTo(self)
        }
    }

    // MARK: lazy properties
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = self.avatarWidth / 2
        return imageView
    }()

    lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.fb_grayColor()
        label.font = UIFont.fb_defaultFontOfSize(14)
        return label;
    }()

    lazy var timelineTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor.blackColor()
        label.font = UIFont.fb_defaultFontOfSize(14)
        return label;
    }()

    //optional: imagesCollectionView or imageView or none
    lazy var imagesCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
        return collectionView
    }()

    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFill
        return imageView
    }()
}
