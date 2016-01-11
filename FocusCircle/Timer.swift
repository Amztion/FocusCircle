//
//  Timer.swift
//  FocusCircle
//
//  Created by Liang Zhao on 16/1/11.
//  Copyright © 2016年 Liang Zhao. All rights reserved.
//

import UIKit

enum TimerState {
    case Running
    case Paused
    case Stopped
}

class Timer: NSObject {

    var name: String! {
        willSet(newName) {
            self.notifyObserverInfoDidChangedOfTimer?(self, newName: newName, newDurationTime: nil)
        }
    }
    
    var durationTime: NSTimeInterval! {
        willSet(newDurationTime) {
            self.notifyObserverInfoDidChangedOfTimer?(self, newName: nil, newDurationTime: newDurationTime)
        }
    }
    
    var state: TimerState = TimerState.Stopped {
        willSet(newState) {
            self.notifyObserverStateDidChangedOfTier?(self, newState: newState)
        }
    }
    
    var remainingTime: NSTimeInterval = 0 {
        willSet(newRemainingTime) {
            if self.state == TimerState.Running {
                self.notifyObserverRemaingTimeDidChangedOfTimer!(self, newRemainingTime: newRemainingTime)
            }
        }
    }
    
    
//    private let identifier: String!
    private var timer: NSTimer?
    
    var notifyObserverStateDidChangedOfTier: ((Timer, newState: TimerState) -> Void)?
    var notifyObserverRemaingTimeDidChangedOfTimer: ((Timer, newRemainingTime: NSTimeInterval) -> Void)?
    var notifyObserverInfoDidChangedOfTimer: ((Timer, newName: String?, newDurationTime: NSTimeInterval?) -> Void)?
    
    init?(name: String, durationTime: NSTimeInterval) {
        super.init()
        self.name = name
        self.durationTime = durationTime
        self.remainingTime = durationTime
    }
    
    //MARK: Observer Operation
    func addObserverOperationWhenStateDidchanged(stateDidChanged: ((Timer, TimerState) -> Void)?, remainingTimeDidChanged: ((Timer, NSTimeInterval) -> Void)?, infoDidChanged: ((Timer, String?, NSTimeInterval?) -> Void)?) {
        self.notifyObserverStateDidChangedOfTier = stateDidChanged
        self.notifyObserverRemaingTimeDidChangedOfTimer = remainingTimeDidChanged
        self.notifyObserverInfoDidChangedOfTimer = infoDidChanged
    }
    
    func removeObserver() {
        self.notifyObserverInfoDidChangedOfTimer = nil
        self.notifyObserverRemaingTimeDidChangedOfTimer = nil
        self.notifyObserverStateDidChangedOfTier = nil
    }
    
    //MARK: Modify Timer
    func renameAs(newName: String) {
        self.name = newName
    }
    
    func modifyDurationTimeTo(newDurationTime: NSTimeInterval) {
        self.durationTime = newDurationTime
        self.remainingTime = newDurationTime
    }
    
    func countDownRemainingTime() {
        if remainingTime > 0 {
            remainingTime -= 1
        }else{
            self.stop()
        }
    }
    
    //MARK: TimerControlProtocol
    func start() -> Bool {
        if state == TimerState.Running {
            return false
        }
        
        state = TimerState.Running
        
        timer = NSTimer(timeInterval: 1, target: self, selector: "countDownRemainingTime", userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timer!, forMode: "NSDefaultRunLoopMode")
        timer?.fire()
        
        return true
    }
    
    func pause() -> Bool {
        if state != TimerState.Running {
            return false
        }
        
        state = TimerState.Paused
        
        timer?.invalidate()
        timer = nil
        
        return true
    }
    
    func stop() -> Bool {
        if state == TimerState.Stopped {
            return false
        }
        
        remainingTime = durationTime
        state = TimerState.Stopped
        
        timer?.invalidate()
        timer = nil
        
        return true
    }
}