//
//  TimerController.swift
//  FocusCircle
//
//  Created by Liang Zhao on 16/1/9.
//  Copyright © 2016年 Liang Zhao. All rights reserved.
//

import UIKit

protocol TimerUIUpdateProtocol: class {
    func updateRemaingTimeUIAtIndex(index: Int)
    func updateTimerStateUIAtIndex(index: Int)
}

class TimerController {

    static var sharedController = TimerController()
    weak var timerUpdateDelegate: TimerUIUpdateProtocol?
    
    private var timersArray = [Timer]()
    
    //MARK: Get Info Of Timers
    func numberOfTimers() -> Int {
        return timersArray.count
    }
    
    func timerInfoAtIndex(index: Int) -> TimerInfo? {
        if index >= timersArray.count {
            return nil
        }else{
            return timersArray[index]
        }
    }
    
    //MARK: Operation With Timer
    func addNewTimerName(name: String, durationTime: NSTimeInterval) -> Bool {
     
        let newTimer = Timer(name: name, durationTime: durationTime)
        
        if let timerToHandle = newTimer {
            timersArray.insert(timerToHandle, atIndex: 0)
        }
        
        return true
    }
    
    func deleteTimerAtIndex(index: Int) -> Bool {
     
        return true
    }
    
    func renameTimerAtIndex(index: Int, name: String) -> Bool {
        
        return true
    }
    
    func modifyTimerAtIndex(index: Int, durationTime: NSTimeInterval) -> Bool {
        
        return true
    }
    
    func startTimerAtIndex(index: Int) -> Bool {
        
        return true
    }
    
    func pauseTimerAtIndex(index: Int) -> Bool {
        
        return true
    }
    
    func resetTimerAtIndex(index: Int) -> Bool {
        
        return true
    }
    
    //MARK: Storage
    private func restoreTimersFromDataBase() {
        
        //Read From Database
        let fakeDatabaseDict = Dictionary<String, String>()
        
        let timer = Timer(dictionary: fakeDatabaseDict)

        if let timerToHandle = timer {
            
            timerToHandle.remainingTimeUpdateOperation! = remainingTimeUpdate
            timerToHandle.timerStateDidChangedOperation! = timerStateDidChanged
            
            timersArray.insert(timerToHandle, atIndex: 0)
        }
    }
    
    private func saveTimerToDatabase() {
        
    }
    
    //MARK: Timer Changed Operation
    func remainingTimeUpdate(updatedTimer: Timer, remainingTime: NSTimeInterval) -> Void {
        let index = self.timersArray.indexOf(updatedTimer)!
        
        self.timerUpdateDelegate?.updateRemaingTimeUIAtIndex(index)
    }
    
    func timerStateDidChanged(updatedTimer: Timer, newState: TimerState) -> Void {
        let index = self.timersArray.indexOf(updatedTimer)!
        
        self.timerUpdateDelegate?.updateTimerStateUIAtIndex(index)
    }
    

    
}
