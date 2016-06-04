//
//  FBTimelineView.swift
//  fatherbook-ios
//
//  Created by Monzy Zhang on 5/28/16.
//  Copyright © 2016 MonzyZhang. All rights reserved.
//

import UIKit
import SDWebImage

private let imageSpace: CGFloat = 10.0
private let imageCellHeightAmountMoreThan4 = (CGRectGetWidth(UIScreen.mainScreen().bounds) - imageSpace * 4) / 3
private let imageCellHeightAmountEqualToOrLessThan4 = (CGRectGetWidth(UIScreen.mainScreen().bounds) - imageSpace * 3) / 2

class FBTimelineView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    private let avatarWidth: CGFloat = 50.0
    private var imageURLs = [FBTimelineImage]()
    var indexPath: NSIndexPath = NSIndexPath(forRow: -1, inSection: 0)
    var isRepost = false
    var hasImages = false

    // MARK: config
    func config(avatarURL url: NSURL? = nil, nickname: String?, text: String?, imageURLs: [FBTimelineImage], indexPath: NSIndexPath) {
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        if url != nil {
            avatarImageView.fb_imageWithURL(url, complete: { (image) in
                if self.indexPath != indexPath {
                    return
                }
                self.avatarImageView.image = image
            })
        } else {
            avatarImageView.image = UIImage(named: "placeholder")
        }
        nicknameLabel.text = isRepost ?"@\(nickname ?? "")": nickname
        timelineTextLabel.text = text
        self.imageURLs = imageURLs
        switch imageURLs.count {
        case 0:
            return
        case 1:
            //imageView
            let imageItem = imageURLs.fb_safeObjectAtIndex(0)
            imageView.sd_setImageWithURL(imageItem?.imageURL, placeholderImage: UIImage(named: "placeholder"))
            let size = imageItem?.imageSize ?? CGSizeZero
            if size.width != 0 && size.height != 0 {
                //imageView
                self.imageView.snp_remakeConstraints { (make) in
                    make.top.equalTo(self.timelineTextLabel.snp_bottom).offset(10.0)
                    make.width.equalTo(self).multipliedBy(0.4)
                    make.height.equalTo(self.imageView.snp_width).multipliedBy(size.height / size.width)
                    make.left.equalTo(self).inset(10.0)
                    make.bottom.equalTo(self)
                }
            }
            break
        default:
            //imageCollectionView
            self.imagesCollectionView.snp_remakeConstraints(closure: { (make) in
                make.top.equalTo(self.timelineTextLabel.snp_bottom)
                make.left.right.equalTo(self)
                make.height.equalTo(imageCollectionViewHeight())
                make.bottom.equalTo(self)
            })
            imagesCollectionView.reloadData()
            break
        }
    }

    // MARK: init
    init(frame: CGRect, isRepost _isRepost: Bool) {
        super.init(frame: frame)
        isRepost = _isRepost
        var bgColor = UIColor.fb_lightGrayColor()
        if !isRepost {
            addSubview(avatarImageView)
            bgColor = UIColor.whiteColor()
        }
        backgroundColor = bgColor
        addSubview(nicknameLabel)
        addSubview(timelineTextLabel)
        addSubview(imagesCollectionView)
        addSubview(imageView)
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func clear() {
        avatarImageView.image = nil
        nicknameLabel.text = ""
        timelineTextLabel.text = ""
        imageView.image = nil
        imagesCollectionView.delegate = nil
        imagesCollectionView.dataSource = nil
        imagesCollectionView.snp_remakeConstraints { (make) in
            make.top.equalTo(timelineTextLabel.snp_bottom)
            make.height.equalTo(0)
        }
        imageView.snp_remakeConstraints { (make) in
            make.top.equalTo(timelineTextLabel.snp_bottom)
            make.left.right.bottom.equalTo(self)
        }
    }

    // MARK: - delegate -
    // MARK: UICollectionViewDelegate

    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let cellHeight = imageCellHeight()
        return CGSizeMake(cellHeight, cellHeight)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 10, 10, 10)
    }

    // MARK: - dataSource -
    // MARK: UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURLs.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = imagesCollectionView.dequeueReusableCellWithReuseIdentifier(FBImageViewCell.description(), forIndexPath: indexPath) as! FBImageViewCell
        cell.imageView.sd_setImageWithURL(imageURLs.fb_safeObjectAtIndex(indexPath.row)?.imageURL, placeholderImage: UIImage(named: "placeholder"))
        return cell
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
            if !isRepost {
                make.top.equalTo(avatarImageView.snp_bottom).offset(10.0)
            } else {
                make.top.equalTo(nicknameLabel.snp_bottom).offset(10.0)
            }
            make.left.right.equalTo(self).inset(10.0)
        }
    }

    private func imageCollectionViewHeight() -> CGFloat {
        var height: CGFloat = 0.0
        var rowCount: CGFloat = 0.0
        let imageCount = imageURLs.count
        if imageCount > 4 {
            //3 a row
            rowCount = CGFloat(ceil(Float(imageCount) / 3.0))
        } else {
            //2 a row
            rowCount = CGFloat(ceil(Float(imageCount) / 2.0))
        }
        height = rowCount * imageCellHeight() + (rowCount + 1) * imageSpace
        return height
    }

    private func imageCellHeight() -> CGFloat {
        if imageURLs.count > 4 {
            return imageCellHeightAmountMoreThan4
        } else {
            return imageCellHeightAmountEqualToOrLessThan4
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
        label.lineBreakMode = .ByWordWrapping
        label.textColor = UIColor.blackColor()
        label.font = UIFont.fb_defaultFontOfSize(14)
        return label;
    }()

    //optional: imagesCollectionView or imageView or none
    lazy var imagesCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.registerClass(FBImageViewCell.self, forCellWithReuseIdentifier: FBImageViewCell.description())
        collectionView.scrollEnabled = false
        collectionView.backgroundColor = UIColor.clearColor()
        return collectionView
    }()

    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
}
