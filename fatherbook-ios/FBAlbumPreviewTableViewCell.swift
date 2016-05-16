//
//  FBAlbumPreviewTableViewCell.swift
//  fatherbook-ios
//
//  Created by Monzy Zhang on 5/16/16.
//  Copyright © 2016 MonzyZhang. All rights reserved.
//

import UIKit
import SnapKit

private let photoThumbCount = 4
private let photoThumbSpace: CGFloat = 14.0
class FBAlbumPreviewTableViewCell: UITableViewCell {
    private lazy var thumbImageViews: [UIImageView] = {
        var _arr = [UIImageView]()
        for i in 0..<photoThumbCount {
            let imgView = UIImageView()
            imgView.opaque = false
            imgView.backgroundColor = UIColor.fb_darkColor()
            _arr.append(imgView)
        }
        return _arr
    }()

    private lazy var label: UILabel = {
        let _label = UILabel()
        _label.text = "Album"
        _label.font = UIFont.fb_defaultFontOfSize(14)
        _label.textColor = UIColor.blackColor()
        return _label
    }()

    // MARK: - init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .DisclosureIndicator
        initSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - public
    func configWithAlbumInfo() {
    }

    // MARK: - action

    // MARK: - private
    private func initSubviews() {
        contentView.addSubview(label)
        label.snp_makeConstraints { (make) in
            make.left.equalTo(8.0)
            make.centerY.equalTo(contentView)
        }
        var preImageView: UIImageView?
        for imgView in thumbImageViews {
            contentView.addSubview(imgView)
            if let preIV = preImageView {
                imgView.snp_makeConstraints(closure: { (make) in
                    make.left.equalTo(preIV.snp_right).offset(photoThumbSpace)
                    make.centerY.equalTo(contentView)
                    make.height.equalTo(preIV)
                    make.width.equalTo(preIV)
                })
            } else {
                imgView.snp_makeConstraints(closure: { (make) in
                    make.left.equalTo(label.snp_right).offset(photoThumbSpace)
                    make.centerY.equalTo(contentView)
                    make.height.equalTo(imgView.snp_width)
                })
            }
            preImageView = imgView
        }
        thumbImageViews.last!.snp_makeConstraints { (make) in
            if accessoryView != nil {
                make.right.equalTo(accessoryView!.snp_left).offset(-10)
            } else {
                make.right.equalTo(contentView).offset(-10)
            }
        }
    }
}
