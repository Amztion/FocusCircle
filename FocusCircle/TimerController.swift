//
//  TimerController.swift
//  FocusCircle
//
//  Created by Liang Zhao on 16/1/9.
//  Copyright © 2016年 Liang Zhao. All rights reserved.
//

import UIKit

protocol TimerUIUpdateProtocol: class {
    func updateTimerUI(remainTime newRemainTime:TimeInterval, at index: Int)
    func updateTimerUI(state newState: TimerState, at index:Int)
    func updateTimerUI(name newName:String?, at index:Int)
    func updateTimerUI(durationTime newDurationTime: TimeInterval?, at index:Int)
}

typealias TimerInfo = (name: String, durationTime: TimeInterval, state: TimerState)

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
    
    func timerInfoAtIndex(_ index: Int) -> TimerInfo? {
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
    func addUIUpdateDelegate(_ delegate: TimerUIUpdateProtocol){
        self.timerUIUpdateDelegate = delegate
    }
    
    func removeUIUpdateDelegate(_ delegate: TimerUIUpdateProtocol){
        self.timerUIUpdateDelegate = nil
    }
    
    //MARK: Operation With Timer
    func addNewTimerWithName(_ name: String, durationTime: TimeInterval) -> Bool {
        if let timer = Timer(name: name, durationTime: durationTime) {
            timersArray.insert(timer, at: 0)
            timer.addTimerUpdatObserver(self)
            databaseController.saveNewTimer(timer)
        }
        
        return true
    }
    
    func deleteTimerAtIndex(_ index: Int) -> Bool {
        if timersArray.count < index - 1 {
            return false
        }
        
        let timer = timersArray[index]
        databaseController.deleteTimerWithIdentifier(timer.identifier)
        
        timersArray.remove(at: index)
     
        return true
    }
    
    func renameTimerAtIndex(_ index: Int, newName: String) -> Bool {
        if timersArray.count < index - 1 {
            return false
        }
        
        timersArray[index].renameAs(newName)
        
        return true
    }
    
    func modifyTimerAtIndex(_ index: Int, newDurationTime: TimeInterval) -> Bool {
        if timersArray.count < index - 1 {
            return false
        }
        
        timersArray[index].modifyDurationTimeTo(newDurationTime)
        
        return true
    }
    
    func startTimerAtIndex(_ index: Int) -> Bool {
        if timersArray.count < index - 1 {
            return false
        }
        
        timersArray[index].start()
        
        return true
    }
    
    func pauseTimerAtIndex(_ index: Int) -> Bool {
        if timersArray.count < index - 1 {
            return false
        }
        
        timersArray[index].pause()
        
        return true
    }
    
    func resetTimerAtIndex(_ index: Int) -> Bool {
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
                timersArray.insert(timer, at: 0)
                timer.addTimerUpdatObserver(self)
            }
            
        }
    }
    
    
    //MARK: TimerUpdateProtocol
    func stateDidChangedOfTimer(_ updatedTimer: Timer, newState: TimerState, newTimeStarted: TimeInterval?, newTimeShouldEnd: TimeInterval?) {
        let index = self.timersArray.index(of: updatedTimer)
        self.timerUIUpdateDelegate?.updateTimerStateUIAtIndex(index!, newState: newState)
    }
    
    func infoDidChangedOfTimer(_ updatedTimer: Timer, newName: String?, newDurationTime: TimeInterval?) {
        let index = self.timersArray.index(of: updatedTimer)
        self.timerUIUpdateDelegate?.updateTimerInfoUIAtIndex(index!, newName: newName, newDurationTime: newDurationTime)
        databaseController.updateInfoOfTimerWithIdentifier(updatedTimer.identifier, newName: newName, newDurationTime: newDurationTime)
    }
    
    func remainingTimeDidChangedOfTimer(_ updatedTimer: Timer, newRemainingTime: TimeInterval) {
        let index = self.timersArray.index(of: updatedTimer)
        self.timerUIUpdateDelegate?.updateRemainingTimeUIAtIndex(index!, newRemainingTime: newRemainingTime)
    }
}
