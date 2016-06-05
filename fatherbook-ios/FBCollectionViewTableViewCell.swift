//
//  FBCollectionViewTableViewCell.swift
//  fatherbook-ios
//
//  Created by Monzy Zhang on 6/5/16.
//  Copyright © 2016 MonzyZhang. All rights reserved.
//

import SnapKit

private let imageSpace: CGFloat = 10.0

class FBCollectionViewTableViewCell: UITableViewCell, UICollectionViewDelegateFlowLayout {
    var itemAmountInRow: Int = 4

    lazy var collectionView: UICollectionView! = {
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.registerClass(FBImageViewCell.self, forCellWithReuseIdentifier: FBImageViewCell.description())
        return collectionView
    }()

    var imageCellWidth: CGFloat {
        return (CGRectGetWidth(UIScreen.mainScreen().bounds) - imageSpace * CGFloat(itemAmountInRow + 1)) / CGFloat(itemAmountInRow)
    }

    // MARK: - UICollectionViewDelegateFlowLayout -
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(imageSpace, imageSpace, imageSpace, imageSpace)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(imageCellWidth, imageCellWidth)
    }

    // MARK: - init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - private
    private func setupConstraints() {
        collectionView.snp_makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
    }
}
