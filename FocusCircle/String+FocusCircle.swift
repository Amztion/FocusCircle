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
}