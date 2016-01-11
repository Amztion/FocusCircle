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
        willSet(newState) {
            self.notifyObserverStateDidChangedOfTier?(self, newState: newState)
        }
    }
    
    override var name: String {
        willSet(newName) {
            self.notifyObserverInfoDidChangedOfTimer?(self, newName: newName, newDurationTime: nil)
        }
    }
    
    override var durationTime: NSTimeInterval! {
        willSet(newDurationTime) {
            self.notifyObserverInfoDidChangedOfTimer?(self, newName: nil, newDurationTime: newDurationTime)
        }
    }
    
    var remainingTime: NSTimeInterval = 0 {
        willSet(newRemainingTime) {
            if self.state == TimerState.Running {
                self.notifyObserverRemaingTimeDidChangedOfTimer!(self, newRemainingTime: newRemainingTime)
            }
        }
    }
    
    private var timer: NSTimer?
    
    var notifyObserverStateDidChangedOfTier: ((Timer, newState: TimerState) -> Void)?
    var notifyObserverRemaingTimeDidChangedOfTimer: ((Timer, newRemainingTime: NSTimeInterval) -> Void)?
    var notifyObserverInfoDidChangedOfTimer: ((Timer, newName: String?, newDurationTime: NSTimeInterval?) -> Void)?
    
    init?(dictionary: NSDictionary) {
        
    }
    
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