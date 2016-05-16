//
//  Array_FBOperation.swift
//  fatherbook-ios
//
//  Created by Monzy Zhang on 5/16/16.
//  Copyright © 2016 MonzyZhang. All rights reserved.
//

import Foundation


extension Array {
    func fb_safeObjectAtIndex(index: Int) -> Element? {
        if self.count > index {
            return self[index]
        } else {
            return nil
        }
    }

    mutating func fb_safeRemoveObjectAdIndex(index: Int) -> Element? {
        let deleted = fb_safeObjectAtIndex(index)
        if deleted != nil {
            self.removeAtIndex(index)
        }
        return deleted
    }
}