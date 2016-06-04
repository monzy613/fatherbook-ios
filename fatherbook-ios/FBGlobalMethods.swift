//
//  FBGlobalMethods.swift
//  fatherbook-ios
//
//  Created by Monzy Zhang on 6/3/16.
//  Copyright © 2016 MonzyZhang. All rights reserved.
//

import SDWebImage


class FBGlobalMethods {
    class func getLocaleImage(withURL url: NSURL!) -> UIImage? {
        let cacheKey = url.absoluteString.componentsSeparatedByString("?").fb_safeObjectAtIndex(0)
        let diskImage = SDImageCache.sharedImageCache().imageFromDiskCacheForKey(cacheKey)
        return diskImage
    }

    class func removeLocaleImage(withURL url: NSURL!) {
        let cacheKey = url.absoluteString.componentsSeparatedByString("?").fb_safeObjectAtIndex(0)
        SDImageCache.sharedImageCache().removeImageForKey(cacheKey, fromDisk: true)
    }
}