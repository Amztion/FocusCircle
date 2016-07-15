//
//  UIButton+FocusCircle.swift
//  FocusCircle
//
//  Created by Liang Zhao on 16/1/11.
//  Copyright © 2016年 Liang Zhao. All rights reserved.
//

import UIKit

extension UIButton {
    func changeButtonToState(_ state: TimerState) {
        switch state {
        case TimerState.stopped, TimerState.paused:
            self.setImage(UIImage(named: "RunningIcon"), for: UIControlState())
        case TimerState.running:
            self.setImage(UIImage(named: "PauseIcon"), for: UIControlState())
        }
    }
}
