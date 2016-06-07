//
//  FBNewTimelineViewController.swift
//  fatherbook-ios
//
//  Created by Monzy Zhang on 6/4/16.
//  Copyright © 2016 MonzyZhang. All rights reserved.
//

import Qiniu
import SIAlertView
import MBProgressHUD
import BUKImagePickerController

private let maxImageCount = 9
private let imageSpace: CGFloat = 10.0
private let imageCellWidth = (CGRectGetWidth(UIScreen.mainScreen().bounds) - imageSpace * 5) / 4.0

class FBNewTimelineViewController: UITableViewController,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout,
    BUKImagePickerControllerDelegate,
    FBImageViewCellDelegate {

    lazy var imagePicker: BUKImagePickerController = {
        let imagePicker = BUKImagePickerController()
        imagePicker.allowsMultipleSelection = true
        imagePicker.maximumNumberOfSelection = UInt(maxImageCount)
        imagePicker.delegate = self
        return imagePicker
    }()

    lazy var selectedImages: [UIImage] = {
        return [UIImage]()
    }()

    private var selectedImageCount: Int = 0 {
        didSet {
            resetCollectionViewHeight()
        }
    }

    var selectionCellHeight: CGFloat = 0.0
    var textViewCellHeight: CGFloat = CGRectGetWidth(UIScreen.mainScreen().bounds) * 0.6


    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBarItems()
        selectedImageCount = 0
    }

    // MARK: - delegate
    // MARK: - FBImageViewCellDelegate -
    func imageViewCellDidPressDeleteButton(cell: FBImageViewCell) {
        if let indexPath = getCollectionView()?.indexPathForCell(cell) {
            selectedImages.removeAtIndex(indexPath.row)
            selectedImageCount -= 1
        }
    }

    // MARK: - BUKImagePickerControllerDelegate -
    func buk_imagePickerController(imagePickerController: BUKImagePickerController!, didFinishPickingAssets assets: [AnyObject]!) {
        guard let assets = assets else {
            imagePicker.dismissViewControllerAnimated(true, completion: nil)
            return
        }
        if assets.count == 0 {
            return
        }
        selectedImages.removeAll()
        for asset in assets {
            let image = UIImage(CGImage: asset.defaultRepresentation().fullScreenImage().takeUnretainedValue())
            selectedImages.append(image)
        }
        selectedImageCount = assets.count
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.popViewControllerAnimated(true)
    }

    func buk_imagePickerControllerDidCancel(imagePickerController: BUKImagePickerController!) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.popViewControllerAnimated(true)
    }

    // MARK: - collectionview delegate -
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if checkIsAddNewCell(indexPath) {
            navigationController?.setNavigationBarHidden(true, animated: true)
            navigationController?.pushViewController(imagePicker, animated: true)
        }
    }

    // MARK: - scrollView dekegate -
    override func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y < 0 {
            getTextView()?.endEditing(true)
        }
    }

    // MARK: - datasource
    // MARK: tableview datasource
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.0
        }
        return 10.0
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = UIColor.clearColor()
        return header
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return selectionCellHeight
        case 1:
            return textViewCellHeight
        default:
            return 0.0
        }
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier(FBCollectionViewTableViewCell.description(), forIndexPath: indexPath) as! FBCollectionViewTableViewCell
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier(FBTextViewTableViewCell.description(), forIndexPath: indexPath) as! FBTextViewTableViewCell
            return cell
        }
    }

    // MARK: - collectionview datasource -
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedImageCount == 9 ?9: selectedImageCount + 1
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(FBImageViewCell.description(), forIndexPath: indexPath) as! FBImageViewCell
        if checkIsAddNewCell(indexPath) {
            cell.longPressEnabled = false
            cell.imageView.image = UIImage(named: "newImagePlaceholder")
        } else {
            cell.longPressEnabled = true
            cell.delegate = self
            cell.imageView.image = selectedImages.fb_safeObjectAtIndex(indexPath.row)
        }
        return cell
    }

    // MARK: - UICollectionViewFlowLayout -
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(imageSpace, imageSpace, imageSpace, imageSpace)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(imageCellWidth, imageCellWidth)
    }

    // MARK: - action
    func sendButtonPressed(sender: UIBarButtonItem) {
        if let text = getTextView()?.text {
            if text == "" && selectedImages.count == 0 {
                MBProgressHUD.showErrorToView("opps, empty timeline", rootView: self.navigationController?.view)
                return
            }
            FBApi.post(withURL: kFBApiPostTimeline,
                       parameters: [
                        kAccount: FBUserManager.sharedManager().user.account ?? "",
                        kPassword: FBUserManager.sharedManager().user.password ?? "",
                        kImages: FBGlobalMethods.getImagesJSONArrayString(selectedImages),
                        kText: text
                ],
                       success: { (json) -> (Void) in
                        print(json)
                        guard let tokenJSONs = json[kTokens].array, let timelineID = json[kID].int else { return }
                        print(tokenJSONs)
                        FBQNManager.sharedManager().timelineImageQueue[timelineID] = (self.selectedImageCount, 0)
                        for (index, tokenJSON) in tokenJSONs.enumerate() {
                            let data = UIImageJPEGRepresentation(self.selectedImages[index], 1.0)
                            if let token = tokenJSON[kToken].string, let filename = tokenJSON[kFilename].string {
                                let upManager = QNUploadManager()
                                upManager.putData(data, key: filename, token: token, complete: { (info, key, res) in
                                    guard let info = info else {return}
                                    if !info.ok {
                                        return
                                    }
                                    if var queuePair = FBQNManager.sharedManager().timelineImageQueue[timelineID] {
                                        queuePair.1 += 1
                                        if queuePair.0 == queuePair.1 {
                                            FBQNManager.sharedManager().timelineImageQueue.removeValueForKey(timelineID)
                                            return
                                        }
                                        FBQNManager.sharedManager().timelineImageQueue[timelineID] = queuePair
                                    }
                                    }, option: nil)
                            }
                        }
                        self.finishEditing()
            }) { (error) -> (Void) in
                MBProgressHUD.showErrorToView("Error", rootView: self.navigationController?.view)
                self.finishEditing()
            }
        }
    }

    func cancelButtonPressed(sender: UIBarButtonItem) {
        getTextView()?.endEditing(true)
        if checkDirty() {
            //SIAlertView
            let alert = SIAlertView(title: "Timeline", andMessage: "确认放弃正在编辑的Timeline?")
            alert.destructiveButtonColor = UIColor.fb_lightColor()
            alert.cancelButtonColor = UIColor.fb_darkColor()
            alert.buttonsListStyle = .Rows
            alert.addButtonWithTitle("是", type: .Destructive, backgroundColor: UIColor.fb_darkColor(), cornerRadius: 4.0, handler: {
                [unowned self] alertView in
                self.finishEditing()
            })
            alert.addButtonWithTitle("否", type: .Cancel, backgroundColor: UIColor.fb_lightColor(), cornerRadius: 4.0, handler:nil)
            alert.transitionStyle = .Fade
            alert.show()
            return
        }
        finishEditing()
    }

    // MARK: - private
    private func checkDirty() -> Bool {
        return getTextView()?.text != "" || selectedImageCount != 0
    }

    private func getCollectionView() -> UICollectionView? {
        return (tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as? FBCollectionViewTableViewCell)?.collectionView
    }

    private func getTextView() -> UITextView? {
        return (tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1)) as? FBTextViewTableViewCell)?.textView
    }

    private func checkIsAddNewCell(indexPath: NSIndexPath) -> Bool {
        if selectedImageCount < 9 {
            return indexPath.row == selectedImageCount
        } else {
            return false
        }
    }

    private func setupTableView() {
        tableView.separatorStyle = .None
        tableView.backgroundColor = UIColor.fb_lightGrayColor()
        tableView.tableFooterView = UIView()
        tableView.registerClass(FBCollectionViewTableViewCell.self, forCellReuseIdentifier: FBCollectionViewTableViewCell.description())
        tableView.registerClass(FBTextViewTableViewCell.self, forCellReuseIdentifier: FBTextViewTableViewCell.description())
    }

    private func setupNavigationBarItems() {
        let sendButton = UIBarButtonItem(title: "send", style: .Done, target: self, action: #selector(sendButtonPressed))
        let cancelButton = UIBarButtonItem(title: "cancel", style: .Plain, target: self, action: #selector(cancelButtonPressed))
        navigationItem.rightBarButtonItem = sendButton
        navigationItem.leftBarButtonItem = cancelButton
    }

    private func resetCollectionViewHeight() {
        let rowCount = CGFloat(ceil(Float(selectedImageCount + 1) / 4.0))
        selectionCellHeight = rowCount * imageCellWidth + (rowCount + 1) * imageSpace
        tableView.reloadData()
        getCollectionView()?.reloadData()
    }

    private func finishEditing() {
        getTextView()?.endEditing(true)
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
