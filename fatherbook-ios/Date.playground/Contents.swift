//: Playground - noun: a place where people can play

import UIKit

let date = NSDate(timeIntervalSince1970: 1463980235)

let imageCount: Int = 9
ceil(Float(imageCount) / 3.0)
let url = NSURL(string: "http://o7b20it1b.bkt.clouddn.com/userAvatar/adm.jpeg?_=1464969079")
(url?.absoluteString)?.componentsSeparatedByString("?")[0]