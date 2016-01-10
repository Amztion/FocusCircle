//
//  TimerInfo.swift
//  FocusCircle
//
//  Created by Liang Zhao on 16/1/10.
//  Copyright © 2016年 Liang Zhao. All rights reserved.
//

import UIKit

enum TimerState {
    case Running
    case Paused
    case Stopped
}

class TimerInfo: NSObject {
    var name: String = ""
    var state = TimerState.Stopped
    var durationTime: NSTimeInterval!
}
