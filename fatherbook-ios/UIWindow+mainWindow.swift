//
//  UIWindow+mainWindow.swift
//  fatherbook-ios
//
//  Created by Monzy Zhang on 5/16/16.
//  Copyright © 2016 MonzyZhang. All rights reserved.
//

import UIKit


extension UIWindow {
    class func mainWindow() -> UIWindow? {
        let frontToBackWindows = UIApplication.sharedApplication().windows.reverse()
        for window in frontToBackWindows {
            if window.windowLevel == UIWindowLevelNormal {
                return window
            }
        }
        return nil
    }
}