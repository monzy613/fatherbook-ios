//
//  FBNewTimelineViewController.swift
//  fatherbook-ios
//
//  Created by Monzy Zhang on 6/4/16.
//  Copyright © 2016 MonzyZhang. All rights reserved.
//

import UIKit
import SnapKit
import BUKPhotoEditViewController
import BUKImagePickerController

private let maxImageCount = 9
private let imageSpace: CGFloat = 5.0
private let imageCellWidth = (CGRectGetWidth(UIScreen.mainScreen().bounds) - 5.0 * 5) / 4.0

class FBNewTimelineViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private var selectedImageCount: Int = 0 {
        didSet {
            resetCollectionViewHeight()
        }
    }
    private lazy var imageSelectionView: UICollectionView! = {
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.registerClass(FBImageViewCell.self, forCellWithReuseIdentifier: FBImageViewCell.description())
        return collectionView
    }()

    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageSelectionView)
        setupConstraints()
        selectedImageCount = 8
    }

    // MARK: - delegate
    // MARK: - collectionview delegate -
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    }

    // MARK: - datasource
    // MARK: - collectionview datasource -
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedImageCount == 9 ?9: selectedImageCount + 1
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(FBImageViewCell.description(), forIndexPath: indexPath) as! FBImageViewCell
        cell.imageView.image = UIImage(named: "newImagePlaceholder")
        return cell
    }

    // MARK: - UICollectionViewFlowLayout -
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(imageCellWidth, imageCellWidth)
    }

    // MARK: - private
    private func setupConstraints() {
        imageSelectionView.snp_makeConstraints { (make) in
            make.top.left.right.equalTo(view)
        }
    }

    private func resetCollectionViewHeight() {
        let rowCount = CGFloat(ceil(Float(selectedImageCount + 1) / 4.0))
        let height = rowCount * imageCellWidth + (rowCount + 1) * 5.0
        imageSelectionView.snp_remakeConstraints { (make) in
            make.top.left.right.equalTo(view)
            make.height.equalTo(height)
        }
        imageSelectionView.reloadData()
    }
}
