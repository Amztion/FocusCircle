//
//  String+FocusCircle.swift
//  FocusCircle
//
//  Created by 赵亮 on 16/1/11.
//  Copyright © 2016年 Liang Zhao. All rights reserved.
//

import Foundation

extension String {
    init(seconds: NSTimeInterval){
        let timeComponentFormat = "02.0"
        let timeComponent = seconds.convertIntoTimeComponent()
        
        self = timeComponent.hour.format(timeComponentFormat) + ":" + timeComponent.minute.format(timeComponentFormat) + ":" + timeComponent.second.format(timeComponentFormat)
    }
    
    func md5() -> String {
        var digest = [UInt8](count: Int(CC_MD5_DIGEST_LENGTH), repeatedValue: 0)
        if let data = self.dataUsingEncoding(NSUTF8StringEncoding) {
            CC_MD5(data.bytes, CC_LONG(data.length), &digest)
        }
        
        var digestHex = ""
        for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
            digestHex += String(format: "%02x", digest[index])
        }
        
        return digestHex
    }
}