//
//  FBTimelineViewController.swift
//  fatherbook-ios
//
//  Created by Monzy Zhang on 5/11/16.
//  Copyright © 2016 MonzyZhang. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVPullToRefresh
import UITableView_FDTemplateLayoutCell

class FBTimelineViewController: UITableViewController, FBTimelineCellDelegate {
    var rootViewController: FBRootViewController?

    var timelines = [FBTimeline]()
    var firstTimelineID: Int = -1
    var lastTimelineID: Int = -1
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadMore()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().postNotificationName(kTIMELINEVCWILLSHOW, object: nil)
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().postNotificationName(kTIMELINEVCWILLDISMISS, object: nil)
    }

    // MARK: - delegate -
    // MARK: - FBTImelineCellDelegate
    func fbTimelineCellDidPressRepostButton(cell: FBTimelineCell) {

    }

    func fbTimelineCellDidPressLikeButton(cell: FBTimelineCell) {
        if let timeline = timelines.fb_safeObjectAtIndex(cell.indexPath.section), let myInfo = FBUserManager.sharedManager().user {
            var apiURL = ""
            if timeline.liked.contains(myInfo) {
                //unlike
                apiURL = kFBApiTimelineUnlike
                timeline.liked.removeAtIndex(timeline.liked.indexOf(myInfo)!)
            } else {
                //like
                apiURL = kFBApiTimelineLike
                timeline.liked.append(myInfo)
            }
            FBApi.post(withURL: apiURL, parameters: [
                kAccount: myInfo.account ?? "",
                kTimelineID: timeline.id
                ], success: { (json) -> (Void) in
                    print("success: \(json)")
                }, failure: { (err) -> (Void) in
                    print("failed")
            })
        }
    }

    func fbTimelineCellDidPressCommentButton(cell: FBTimelineCell) {

    }

    // MARK: - Table view delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    // MARK: Scroll view delegate
    override func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y < 0 {
            rootViewController?.openHeader()
        } else if velocity.y > 0 {
            rootViewController?.closeHeader()
        }
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return timelines.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(FBTimelineCell.description(), forIndexPath: indexPath) as! FBTimelineCell
        if let timeline = timelines.fb_safeObjectAtIndex(indexPath.section) {
            cell.delegate = self
            cell.indexPath = indexPath
            cell.configWithTimeline(timeline, indexPath: indexPath)
        }
        return cell
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableView.fd_heightForCellWithIdentifier(FBTimelineCell.description(), cacheByIndexPath: indexPath, configuration: {
            (cell) in
            if let timeline = self.timelines.fb_safeObjectAtIndex(indexPath.section) {
                (cell as? FBTimelineCell)?.indexPath = indexPath
                (cell as? FBTimelineCell)?.configWithTimeline(timeline, indexPath: indexPath)
            }
        })
    }

    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }

    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        return view
    }

    // MARK: private
    private func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .SingleLine
        tableView.backgroundColor = UIColor.fb_lightGrayColor()
        tableView.addInfiniteScrollingWithActionHandler { 
            [unowned self] in
            self.loadMore()
        }
        tableView.addPullToRefreshWithActionHandler {
            [unowned self] in
            self.loadNew()
        }
        tableView.pullToRefreshView
        tableView.registerClass(FBTimelineCell.self, forCellReuseIdentifier: FBTimelineCell.description())
    }

    // MARK: load
    private func loadNew() {
        guard let account = FBUserManager.sharedManager().user.account else {
            return
        }
        FBApi.get(withURL: kFBApiGetTimelineByFollowing, parameters: [
            kAccount: account,
            kMinID: firstTimelineID
            ], success: { (json) -> (Void) in
                self.stopLoading()
                if let timelineJSONs = json[kTimelines].array {
                    if timelineJSONs.count == 0 {
                        return
                    }
                    for timelineJSON in timelineJSONs.reverse() {
                        self.timelines.insert(FBTimeline(json: timelineJSON), atIndex: 0)
                    }
                    let newSections = NSIndexSet(indexesInRange: NSMakeRange(0, timelineJSONs.count))
                    self.firstTimelineID = self.timelines.first?.id ?? -1
                    self.lastTimelineID = self.timelines.last?.id ?? -1
                    self.tableView.insertSections(newSections, withRowAnimation: UITableViewRowAnimation.Top)
                    
                }
            }) { (err) -> (Void) in
                self.stopLoading()
        }
    }

    private func loadMore() {
        guard let account = FBUserManager.sharedManager().user.account else {
            return
        }
        FBApi.get(withURL: kFBApiGetTimelineByFollowing, parameters: [
            kAccount: account,
            kCount: 5,
            kMaxID: lastTimelineID
            ], success: {
            (json) -> (Void) in
            self.stopLoading()
            if let timelineJSONs = json[kTimelines].array {
                if timelineJSONs.count == 0 {
                    self.tableView.showsInfiniteScrolling = false
                    return
                }
                let beforeAmount = self.timelines.count
                for timelineJSON in timelineJSONs {
                    self.timelines.append(FBTimeline(json: timelineJSON))
                }
                let afterAmount = self.timelines.count
                let newSections = NSIndexSet(indexesInRange: NSMakeRange(beforeAmount, afterAmount - beforeAmount))
                self.firstTimelineID = self.timelines.first?.id ?? -1
                self.lastTimelineID = self.timelines.last?.id ?? -1
                self.tableView.insertSections(newSections, withRowAnimation: UITableViewRowAnimation.Bottom)

            }
            }) {
                (err) -> (Void) in
                self.stopLoading()
                print(err)
        }
    }

    private func stopLoading() {
        tableView.pullToRefreshView.stopAnimating()
        tableView.infiniteScrollingView.stopAnimating()
    }
}
