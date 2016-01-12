//
//  TimerController.swift
//  FocusCircle
//
//  Created by Liang Zhao on 16/1/9.
//  Copyright © 2016年 Liang Zhao. All rights reserved.
//

import UIKit

protocol TimerUIUpdateProtocol: class {
    func updateRemainingTimeUIAtIndex(index: Int, newRemainingTime: NSTimeInterval)
    func updateTimerStateUIAtIndex(index: Int, newState: TimerState)
    func updateTimerInfoUIAtIndex(index: Int, newName: String?, newDurationTime: NSTimeInterval?)
}

typealias TimerInfo = (name: String, durationTime: NSTimeInterval, state: TimerState)

class TimerController {

    static var sharedController = TimerController()
    weak var timerUpdateDelegate: TimerUIUpdateProtocol?
    
    let databaseController = DatabaseController.sharedController
    
    private var timersArray = [Timer]()
    
    //MARK: Get Info Of Timers
    func numberOfTimers() -> Int {
        return timersArray.count
    }
    
    func timerInfoAtIndex(index: Int) -> TimerInfo? {
        if index >= timersArray.count {
            return nil
        }else{
            let timer = timersArray[index]
            return (timer.name, timer.durationTime, timer.state)
        }
    }
    
    //MARK: Operation With Timer
    func addNewTimerWithName(name: String, durationTime: NSTimeInterval) -> Bool {
        if let timer = Timer(name: name, durationTime: durationTime) {
            timersArray.insert(timer, atIndex: 0)
            timer.addObserverOperationWhenStateDidchanged(timerStateDidChanged, remainingTimeDidChanged: remainingTimeUpdate, infoDidChanged: timerInfoDidChanged)
            
            databaseController.saveNewTimer(timer)
        }
        
        return true
    }
    
    func deleteTimerAtIndex(index: Int) -> Bool {
        if timersArray.count < index - 1 {
            return false
        }
        
        timersArray.removeAtIndex(index)
     
        return true
    }
    
    func renameTimerAtIndex(index: Int, newName: String) -> Bool {
        if timersArray.count < index - 1 {
            return false
        }
        
        timersArray[index].renameAs(newName)
        
        return true
    }
    
    func modifyTimerAtIndex(index: Int, newDurationTime: NSTimeInterval) -> Bool {
        if timersArray.count < index - 1 {
            return false
        }
        
        timersArray[index].modifyDurationTimeTo(newDurationTime)
        
        return true
    }
    
    func startTimerAtIndex(index: Int) -> Bool {
        if timersArray.count < index - 1 {
            return false
        }
        
        timersArray[index].start()
        
        return true
    }
    
    func pauseTimerAtIndex(index: Int) -> Bool {
        if timersArray.count < index - 1 {
            return false
        }
        
        timersArray[index].pause()
        
        return true
    }
    
    func resetTimerAtIndex(index: Int) -> Bool {
        if timersArray.count < index - 1 {
            return false
        }
        
        timersArray[index].stop()
        
        return true
    }
    
    //MARK: Storage
    private func restoreTimersFromDataBase() {
        
    }
    
    private func saveTimerToDatabase() {
        
    }
    
    //MARK: Timer Changed Operation
    func remainingTimeUpdate(updatedTimer: Timer, remainingTime: NSTimeInterval) -> Void {
        let index = self.timersArray.indexOf(updatedTimer)!
        self.timerUpdateDelegate?.updateRemainingTimeUIAtIndex(index, newRemainingTime: remainingTime)
    }
    
    func timerStateDidChanged(updatedTimer: Timer, newState: TimerState) -> Void {
        let index = self.timersArray.indexOf(updatedTimer)!
        self.timerUpdateDelegate?.updateTimerStateUIAtIndex(index, newState: newState)
    }
    
    func timerInfoDidChanged(updateTimer: Timer, newName: String?, newDurationTime: NSTimeInterval?) -> Void {
        let index = self.timersArray.indexOf(updateTimer)!
        self.timerUpdateDelegate?.updateTimerInfoUIAtIndex(index, newName: newName, newDurationTime: newDurationTime)
        databaseController.updateInfoOfTimer(updateTimer)
    }
}
