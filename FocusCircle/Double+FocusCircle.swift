//
//  Double+FocusCircle.swift
//  FocusCircle
//
//  Created by 赵亮 on 16/1/11.
//  Copyright © 2016年 Liang Zhao. All rights reserved.
//

import Foundation

extension Double {
    func convertIntoTimeComponent() -> TimeComponent {
        var timeComponent = TimeComponent()
        
        timeComponent.second = (self.truncatingRemainder(dividingBy: 3600.0)).truncatingRemainder(dividingBy: 60.0)
        timeComponent.minute = ((self.truncatingRemainder(dividingBy: 3600.0)) - timeComponent.second ) / 60.0
        timeComponent.hour = (self - self.truncatingRemainder(dividingBy: 3600)) / 3600.0
        
        return timeComponent
    }
    
    func format(_ f: String) -> String {
        return NSString(format: "%\(f)f", self) as String
    }
}
