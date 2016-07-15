//
//  Timer.swift
//  FocusCircle
//
//  Created by Liang Zhao on 16/1/11.
//  Copyright © 2016年 Liang Zhao. All rights reserved.
//

import UIKit

protocol TimerUpdateObserverProtocol:class {
    func stateDidChangedOfTimer(_ updatedTimer:Timer, newState: TimerState, newTimeStarted: TimeInterval?, newTimeShouldEnd: TimeInterval?)
    func infoDidChangedOfTimer(_ updatedTimer:Timer, newName: String?, newDurationTime: TimeInterval?)
    func remainingTimeDidChangedOfTimer(_ updatedTimer:Timer, newRemainingTime: TimeInterval)
}

enum TimerState: Int {
    case running = 0
    case paused = 1
    case stopped = 2
}

class Timer: NSObject {
    var identifier: String!
    
    var name: String! {
        willSet(newName) {
            self.timerUpdateObserver?.infoDidChangedOfTimer(self, newName: newName, newDurationTime: nil)
        }
    }
    
    var durationTime: TimeInterval! {
        willSet(newDurationTime) {
            self.timerUpdateObserver?.infoDidChangedOfTimer(self, newName: nil, newDurationTime: newDurationTime)
        }
    }
    
    var state: TimerState = TimerState.stopped {
        willSet(newState) {
            self.timerUpdateObserver?.stateDidChangedOfTimer(self, newState: newState, newTimeStarted: nil, newTimeShouldEnd: nil)
        }
    }
    
    var remainingTime: TimeInterval = 0 {
        willSet(newRemainingTime) {
            if self.state != TimerState.stopped {
                self.timerUpdateObserver?.remainingTimeDidChangedOfTimer(self, newRemainingTime: newRemainingTime)
            }
        }
    }
    
    var timeStarted: TimeInterval?
    var timeShouldEnd: TimeInterval?
    
    private var timer: Foundation.Timer?
    
//    var observers = [TimerUpdateObserverProtocol]()
    private weak var timerUpdateObserver: TimerUpdateObserverProtocol?
    
    init?(name: String, durationTime: TimeInterval) {
        super.init()
        self.identifier = (String(Date().timeIntervalSince1970) + String(drand48())).md5()
        self.name = name
        self.durationTime = durationTime
        self.remainingTime = durationTime
    }
    
    init?(dataBaseDict:[NSObject:AnyObject]){
        super.init()
        self.identifier = dataBaseDict["identifier"] as! String
        self.name = dataBaseDict["name"] as! String
        self.durationTime = dataBaseDict["durationTime"] as! TimeInterval
        self.state = TimerState(rawValue: dataBaseDict["state"] as! Int)!
        self.timeStarted = dataBaseDict["timeStarted"] as? TimeInterval
        self.timeShouldEnd = dataBaseDict["timeShoudleEnd"] as? TimeInterval
    }
    
    //MARK: Observer Operation
    func addTimerUpdatObserver(_ observer: TimerUpdateObserverProtocol){
        timerUpdateObserver = observer
    }
    
    func removeTimerUpdateObserver(_ ovserver: TimerUpdateObserverProtocol){
        timerUpdateObserver = nil
    }
    
    //MARK: Modify Timer
    func renameAs(_ newName: String) {
        self.name = newName
    }
    
    func modifyDurationTimeTo(_ newDurationTime: TimeInterval) {
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
        if state == TimerState.running {
            return false
        }
        
        state = TimerState.running
        timeStarted = Date().timeIntervalSince1970
        timeShouldEnd = Date().timeIntervalSince1970 + remainingTime
        
        timer = Foundation.Timer(timeInterval: 1, target: self, selector: "countDownRemainingTime", userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: "NSDefaultRunLoopMode" as RunLoopMode)
        timer?.fire()
        
        return true
    }
    
    func pause() -> Bool {
        if state != TimerState.running {
            return false
        }
        
        state = TimerState.paused
        
        timer?.invalidate()
        timer = nil
        
        return true
    }
    
    func stop() -> Bool {
        if state == TimerState.stopped {
            return false
        }
        
        remainingTime = durationTime
        state = TimerState.stopped
        
        timer?.invalidate()
        timer = nil
        
        return true
    }
}
