//
//  Timer.swift
//  FocusCircle
//
//  Created by Liang Zhao on 16/1/11.
//  Copyright © 2016年 Liang Zhao. All rights reserved.
//

import UIKit

protocol TimerUpdateObserverProtocol:class {
    func stateDidChangedOfTimer(updatedTimer:Timer, newState: TimerState, newTimeStarted: NSTimeInterval?, newTimeShouldEnd: NSTimeInterval?)
    func infoDidChangedOfTimer(updatedTimer:Timer, newName: String?, newDurationTime: NSTimeInterval?)
    func remainingTimeDidChangedOfTimer(updatedTimer:Timer, newRemainingTime: NSTimeInterval)
}

enum TimerState: Int {
    case Running = 0
    case Paused = 1
    case Stopped = 2
}

class Timer: NSObject {
    var identifier: String!
    
    var name: String! {
        willSet(newName) {
            self.timerUpdateObserver?.infoDidChangedOfTimer(self, newName: newName, newDurationTime: nil)
        }
    }
    
    var durationTime: NSTimeInterval! {
        willSet(newDurationTime) {
            self.timerUpdateObserver?.infoDidChangedOfTimer(self, newName: nil, newDurationTime: newDurationTime)
        }
    }
    
    var state: TimerState = TimerState.Stopped {
        willSet(newState) {
            self.timerUpdateObserver?.stateDidChangedOfTimer(self, newState: newState, newTimeStarted: nil, newTimeShouldEnd: nil)
        }
    }
    
    var remainingTime: NSTimeInterval = 0 {
        willSet(newRemainingTime) {
            if self.state != TimerState.Stopped {
                self.timerUpdateObserver?.remainingTimeDidChangedOfTimer(self, newRemainingTime: newRemainingTime)
            }
        }
    }
    
    var timeStarted: NSTimeInterval?
    var timeShouldEnd: NSTimeInterval?
    
    private var timer: NSTimer?
    
//    var observers = [TimerUpdateObserverProtocol]()
    private weak var timerUpdateObserver: TimerUpdateObserverProtocol?
    
    init?(name: String, durationTime: NSTimeInterval) {
        super.init()
        self.identifier = (String(NSDate().timeIntervalSince1970) + String(drand48())).md5()
        self.name = name
        self.durationTime = durationTime
        self.remainingTime = durationTime
    }
    
    init?(dataBaseDict:[NSObject:AnyObject]){
        super.init()
        self.identifier = dataBaseDict["identifier"] as! String
        self.name = dataBaseDict["name"] as! String
        self.durationTime = dataBaseDict["durationTime"] as! NSTimeInterval
        self.state = TimerState(rawValue: dataBaseDict["state"] as! Int)!
        self.timeStarted = dataBaseDict["timeStarted"] as? NSTimeInterval
        self.timeShouldEnd = dataBaseDict["timeShoudleEnd"] as? NSTimeInterval
    }
    
    //MARK: Observer Operation
    func addTimerUpdatObserver(observer: TimerUpdateObserverProtocol){
        timerUpdateObserver = observer
    }
    
    func removeTimerUpdateObserver(ovserver: TimerUpdateObserverProtocol){
        timerUpdateObserver = nil
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
        timeStarted = NSDate().timeIntervalSince1970
        timeShouldEnd = NSDate().timeIntervalSince1970 + remainingTime
        
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