//
//  JSON+AppendOperation.swift
//  fatherbook-ios
//
//  Created by Monzy Zhang on 5/23/16.
//  Copyright © 2016 MonzyZhang. All rights reserved.
//

import SwiftyJSON

extension JSON{
    mutating func appendIfArray(json:JSON){
        if var arr = self.array{
            arr.append(json)
            self = JSON(arr);
        }
    }

    mutating func appendIfDictionary(key:String, json:JSON){
        if var dict = self.dictionary{
            dict[key] = json;
            self = JSON(dict);
        }
    }
}