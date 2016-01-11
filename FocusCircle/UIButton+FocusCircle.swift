//
//  UIButton+FocusCircle.swift
//  FocusCircle
//
//  Created by Liang Zhao on 16/1/11.
//  Copyright © 2016年 Liang Zhao. All rights reserved.
//

import UIKit

extension UIButton {
    func changeButtonToState(state: TimerState) {
        switch state {
        case TimerState.Stopped, TimerState.Paused:
            self.setImage(UIImage(named: "RunningIcon"), forState: UIControlState.Normal)
        case TimerState.Running:
            self.setImage(UIImage(named: "PauseIcon"), forState: UIControlState.Normal)
        }
    }
}