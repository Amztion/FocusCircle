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

class TimerController: TimerUpdateObserverProtocol {

    static var sharedController = TimerController()
    private weak var timerUIUpdateDelegate: TimerUIUpdateProtocol?
    
    let databaseController = DatabaseController.sharedController
    
    private var timersArray = [Timer]()
    
    init(){
        self.restoreTimersFromDataBase()
    }
    
    //MARK: Get Info Of Timers
    func numberOfTimers() -> Int {
        return timersArray.count
    }
    
    func timerInfoAtIndex(index: Int) -> TimerInfo? {
        if index < 0 {
            return nil
        }
        if index >= timersArray.count {
            return nil
        }else{
            let timer = timersArray[index]
            return (timer.name, timer.durationTime, timer.state)
        }
    }
    
    //MARK: Timer UI Update Delegate
    func addUIUpdateDelegate(delegate: TimerUIUpdateProtocol){
        self.timerUIUpdateDelegate = delegate
    }
    
    func removeUIUpdateDelegate(delegate: TimerUIUpdateProtocol){
        self.timerUIUpdateDelegate = nil
    }
    
    //MARK: Operation With Timer
    func addNewTimerWithName(name: String, durationTime: NSTimeInterval) -> Bool {
        if let timer = Timer(name: name, durationTime: durationTime) {
            timersArray.insert(timer, atIndex: 0)
            timer.addTimerUpdatObserver(self)
            databaseController.saveNewTimer(timer)
        }
        
        return true
    }
    
    func deleteTimerAtIndex(index: Int) -> Bool {
        if timersArray.count < index - 1 {
            return false
        }
        
        let timer = timersArray[index]
        databaseController.deleteTimerWithIdentifier(timer.identifier)
        
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
        let timerInfoDicts = databaseController.readAllTimersFromDatabase()
        for timerDictionary in timerInfoDicts! {
            if let timer = Timer(dataBaseDict: timerDictionary){
                timersArray.insert(timer, atIndex: 0)
                timer.addTimerUpdatObserver(self)
            }
            
        }
    }
    
    
    //MARK: TimerUpdateProtocol
    func stateDidChangedOfTimer(updatedTimer: Timer, newState: TimerState, newTimeStarted: NSTimeInterval?, newTimeShouldEnd: NSTimeInterval?) {
        let index = self.timersArray.indexOf(updatedTimer)
        self.timerUIUpdateDelegate?.updateTimerStateUIAtIndex(index!, newState: newState)
    }
    
    func infoDidChangedOfTimer(updatedTimer: Timer, newName: String?, newDurationTime: NSTimeInterval?) {
        let index = self.timersArray.indexOf(updatedTimer)
        self.timerUIUpdateDelegate?.updateTimerInfoUIAtIndex(index!, newName: newName, newDurationTime: newDurationTime)
        databaseController.updateInfoOfTimerWithIdentifier(updatedTimer.identifier, newName: newName, newDurationTime: newDurationTime)
    }
    
    func remainingTimeDidChangedOfTimer(updatedTimer: Timer, newRemainingTime: NSTimeInterval) {
        let index = self.timersArray.indexOf(updatedTimer)
        self.timerUIUpdateDelegate?.updateRemainingTimeUIAtIndex(index!, newRemainingTime: newRemainingTime)
    }
}
