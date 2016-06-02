//
//  FBTimelineViewController.swift
//  fatherbook-ios
//
//  Created by Monzy Zhang on 5/11/16.
//  Copyright © 2016 MonzyZhang. All rights reserved.
//

import UIKit
import SwiftyJSON
import UITableView_FDTemplateLayoutCell

class FBTimelineViewController: UITableViewController, FBTimelineCellDelegate {
    var timelines = [FBTimeline]()
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadTimelines()
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
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(FBTimelineCell.self), forIndexPath: indexPath) as! FBTimelineCell
        if let timeline = timelines.fb_safeObjectAtIndex(indexPath.section) {
            cell.delegate = self
            cell.indexPath = indexPath
            cell.configWithTimeline(timeline, indexPath: indexPath)
        }
        return cell
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableView.fd_heightForCellWithIdentifier(NSStringFromClass(FBTimelineCell.self), cacheByIndexPath: indexPath, configuration: {
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

    // MARK: private
    private func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .SingleLine
        tableView.registerClass(FBTimelineCell.self, forCellReuseIdentifier: NSStringFromClass(FBTimelineCell.self))
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(loadTimelines), forControlEvents: .ValueChanged)
    }

    // MARK: load
    @objc private func loadTimelines() {
        guard let account = FBUserManager.sharedManager().user.account else {
            return
        }
        FBApi.get(withURL: kFBApiGetTimelineByFollowing, parameters: [
            kAccount: account,
            kCount: 10
            ], success: {
            (json) -> (Void) in
            self.refreshControl?.endRefreshing()
            if let timelineJSONs = json[kTimelines].array {
                self.timelines.removeAll()
                for timelineJSON in timelineJSONs {
                    self.timelines.append(FBTimeline(json: timelineJSON))
                }
                self.timelines.sortInPlace({ (timeline1, timeline2) -> Bool in
                    return timeline1.id > timeline2.id
                })
                self.tableView.reloadData()
            }
            }) {
                (err) -> (Void) in
                self.refreshControl?.endRefreshing()
                print(err)
        }
    }
}
