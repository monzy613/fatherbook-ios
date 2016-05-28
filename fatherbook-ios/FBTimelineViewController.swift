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

class FBTimelineViewController: UITableViewController {
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

    // MARK: - Table view delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return timelines.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(FBTimelineCell.self), forIndexPath: indexPath) as! FBTimelineCell
        if let timeline = timelines.fb_safeObjectAtIndex(indexPath.row) {
            cell.configWithTimeline(timeline)
        }
        return cell
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableView.fd_heightForCellWithIdentifier(NSStringFromClass(FBTimelineCell.self), cacheByIndexPath: indexPath, configuration: {
            [unowned self] (cell) in
            if let timeline = self.timelines.fb_safeObjectAtIndex(indexPath.row) {
                (cell as? FBTimelineCell)?.configWithTimeline(timeline)
            }
        })
    }

    // MARK: private
    private func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.registerClass(FBTimelineCell.self, forCellReuseIdentifier: NSStringFromClass(FBTimelineCell.self))
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(loadTimelines), forControlEvents: .ValueChanged)
    }

    // MARK: load
    @objc private func loadTimelines() {
        FBApi.get(withURL: kFBApiGetTimeline, parameters: [kAccount : "adm"], success: {
            [unowned self] (json) -> (Void) in
            self.refreshControl?.endRefreshing()
            if let timelineJSONs = json[kTimelines].array {
                self.timelines.removeAll()
                for timelineJSON in timelineJSONs {
                    print(timelineJSON)
                    self.timelines.append(FBTimeline(json: timelineJSON))
                }
                self.tableView.reloadData()
            }
            }) {
                [unowned self] (err) -> (Void) in
                self.refreshControl?.endRefreshing()
                print(err)
        }
    }
}
