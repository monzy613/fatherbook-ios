//
//  UIImageView+FBOperation.swift
//  fatherbook-ios
//
//  Created by Monzy Zhang on 6/3/16.
//  Copyright © 2016 MonzyZhang. All rights reserved.
//

import UIKit
import SDWebImage

extension UIImageView {
    func fb_imageWithURL(url: NSURL!, complete: ((UIImage!) -> ())? ) {
        guard let url = url else {return}
        if complete == nil {
            return
        }

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { 
            if let diskImage = FBGlobalMethods.getLocaleImage(withURL: url) {
                dispatch_async(dispatch_get_main_queue(), { 
                    complete!(diskImage)
                })
                return
            }

            SDWebImageDownloader.sharedDownloader().downloadImageWithURL(url, options: .HighPriority, progress: nil, completed: { (image, data, error, finished) in
                if let image = image {
                    let cacheKey = url.absoluteString.componentsSeparatedByString("?").fb_safeObjectAtIndex(0)
                    SDImageCache.sharedImageCache().storeImage(image, forKey: cacheKey, toDisk: true)
                    print(url.absoluteString)
                    complete!(image)
                }
            })
        }
    }
}