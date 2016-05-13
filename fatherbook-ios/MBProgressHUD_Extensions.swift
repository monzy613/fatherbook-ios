//
//  MBProgressHUD_Extensions.swift
//  fatherbook-ios
//
//  Created by Monzy Zhang on 16/5/9.
//  Copyright © 2016年 MonzyZhang. All rights reserved.
//

import MBProgressHUD

extension MBProgressHUD {
    class func showErrorToView(message: String, rootView: UIView!) {
        let hud = MBProgressHUD.showHUDAddedTo(rootView, animated: true)
        hud.labelFont = UIFont.fb_defaultFontOfSize(14)
        let errorView = UIImageView(image: UIImage(named: "error-icon"))
        errorView.frame = CGRectMake(0, 0, 30.0, 37.5)
        hud.customView = errorView
        hud.mode = .CustomView
        hud.labelText = message
        hud.hide(true, afterDelay: 0.7)
    }

    class func showSuccessToView(message: String, rootView: UIView!) {
        let hud = MBProgressHUD.showHUDAddedTo(rootView, animated: true)
        hud.labelFont = UIFont.fb_defaultFontOfSize(14)
        let successView = UIImageView(image: UIImage(named: "success-icon"))
        successView.frame = CGRectMake(0, 0, 30.0, 37.5)
        hud.customView = successView
        hud.mode = .CustomView
        hud.labelText = message
        hud.hide(true, afterDelay: 0.7)
    }

    class func showLoadingToView(message: String = "", rootView: UIView!) -> MBProgressHUD {
        let hud = MBProgressHUD.showHUDAddedTo(rootView, animated: true)
        hud.labelFont = UIFont.fb_defaultFontOfSize(14)
        hud.mode = .Indeterminate
        hud.labelText = message
        return hud
    }
}