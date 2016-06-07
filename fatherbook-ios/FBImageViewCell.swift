//
//  FBImageViewCell.swift
//  fatherbook-ios
//
//  Created by Monzy Zhang on 5/30/16.
//  Copyright © 2016 MonzyZhang. All rights reserved.
//

import UIKit
import SnapKit

protocol FBImageViewCellDelegate: class {
    func imageViewCellDidPressDeleteButton(cell: FBImageViewCell)
}

class FBImageViewCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    weak var delegate: FBImageViewCellDelegate?

    var longPressEnabled = false {
        didSet {
            if longPressEnabled == true {
                // init long press gesture
                longPressGesture = UILongPressGestureRecognizer(target: self, action:#selector(longPressHandler))
                longPressGesture?.delegate = self
                imageView.addGestureRecognizer(longPressGesture!)

                // init tap gestureRecognizer
                tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
                tapGesture?.delegate
                imageView.addGestureRecognizer(tapGesture!)

                // init deleteButton
                contentView.addSubview(deleteButton)
                deleteButton.snp_makeConstraints(closure: { (make) in
                    make.center.equalTo(contentView)
                    make.height.equalTo(contentView).multipliedBy(0.5)
                    make.width.equalTo(contentView).multipliedBy(0.5)
                })
            } else {
                // remove long press gesture
                deleteButton?.removeFromSuperview()
                deleteButton = nil
                if longPressGesture != nil {
                    imageView.removeGestureRecognizer(longPressGesture!)
                    longPressGesture = nil
                }
                if tapGesture != nil {
                    imageView.removeGestureRecognizer(tapGesture!)
                    tapGesture = nil
                }
                self.deleteButton?.removeFromSuperview()
                self.deleteButton = nil
            }
        }
    }

    var editing = false

    var longPressGesture: UILongPressGestureRecognizer?
    var tapGesture: UITapGestureRecognizer?

    // MARK: - public

    func showDeleteButton() {
        if editing == true {
            return
        }
        editing = true
        UIView.animateWithDuration(0.25) {
            self.deleteButton.transform = CGAffineTransformIdentity
            self.deleteButton.alpha = 0.9
        }
    }

    func dismissDeleteButton() {
        if editing == false {
            return
        }
        editing = false
        UIView.animateWithDuration(0.25) {
            self.deleteButton.transform = CGAffineTransformMakeScale(0.1, 0.1)
            self.deleteButton.alpha = 0.0
        }
    }

    // MARK: - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.snp_makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        imageView.image = nil
        delegate = nil
        longPressEnabled = false
        dismissDeleteButton()
    }

    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        return longPressEnabled
    }

    // MARK: - event  handlers
    @objc private func longPressHandler(sender: UILongPressGestureRecognizer) {
        showDeleteButton()
    }

    @objc private func tapGestureHandler(sender: UITapGestureRecognizer) {
        dismissDeleteButton()
    }

    @objc private func deleteButtonPressed(sender: UIButton) {
        dismissDeleteButton()
        delegate?.imageViewCellDidPressDeleteButton(self)
    }

    // MARK: - lazy properties
    lazy var imageView: UIImageView! = {
        let imageView = UIImageView()
        imageView.userInteractionEnabled = true
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    lazy var deleteButton: UIButton! = {
        let delButton = UIButton()
        delButton.alpha = 0.0
        delButton.setBackgroundImage(UIImage(named: "deleteIcon"), forState: .Normal)
        delButton.addTarget(self, action: #selector(deleteButtonPressed), forControlEvents: .TouchUpInside)
        return delButton
    }()
}
