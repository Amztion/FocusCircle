//
//  Timer.swift
//  FocusCircle
//
//  Created by Liang Zhao on 16/1/9.
//  Copyright © 2016年 Liang Zhao. All rights reserved.
//

import UIKit

protocol TimerControlProtocol {
    func start() -> Bool
    func pause() -> Bool
    func stop() -> Bool
}

class Timer: TimerInfo, TimerControlProtocol {
    
    override var state: TimerState {
        didSet(newState) {
            timerStateDidChangedOperation!(timer: self, state: newState)
        }
    }
    
    var remainingTime: NSTimeInterval = 0 {
        didSet(newRemainingTime) {
            self.remainingTimeUpdateOperation!(timer: self, remainingTime: newRemainingTime)
        }
    }
    
    private var timer: NSTimer?
    
    var timerStateDidChangedOperation: ((timer: Timer, state: TimerState) -> Void)?
    var remainingTimeUpdateOperation: ((timer: Timer, remainingTime: NSTimeInterval) -> Void)?
    
    init?(dictionary: NSDictionary) {
        
    }
    
    init?(name: String?, durationTime: NSTimeInterval) {
        super.init()
        
        self.name = name
        self.durationTime = durationTime
        self.remainingTime = durationTime
    }
    
    
    //MARK: TimerControlProtocol
    func start() -> Bool {
        state = TimerState.Running
        
        return true
    }
    
    func pause() -> Bool {
        state = TimerState.Paused
        
        return true
    }
    
    func stop() -> Bool {
        state = TimerState.Stopped
        
        return true
    }
    
    
}
