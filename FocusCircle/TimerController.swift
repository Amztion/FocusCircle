//
//  TimerController.swift
//  FocusCircle
//
//  Created by Liang Zhao on 16/1/9.
//  Copyright © 2016年 Liang Zhao. All rights reserved.
//

import UIKit

protocol TimerUpdateProtocol {
    func updateRemaingTimeUIAtIndex(index: Int)
    func updateTimerStateUIAtIndex(index: Int)
}

class TimerController {

    static var sharedController = TimerController()
    var viewControllerDelegate: TimerUpdateProtocol?
    
    private var timersArray = [Timer]()
    
    //MARK: Get Timers Info
    func numbersOfTimers() -> Int {
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
     
        return true
    }
    
    func deleteTimerAtIndex(index: Int) -> Bool {
     
        return true
    }
    
    func renameTimerAtIndex(index: Int, name: String) -> Bool {
        
        return true
    }
    
    func modifyTimrAtIndex(index: Int, durationTime: NSTimeInterval) -> Bool {
        
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
            
            timersArray.append(timerToHandle)
        }
    }
    
    private func saveTimerToDatabase() {
        
    }
    
    //MARK: Timer Changed Operation
    func remainingTimeUpdate(updatedTimer: Timer, remainingTime: NSTimeInterval) -> Void {
        let index = self.timersArray.indexOf(updatedTimer)!
        
        self.viewControllerDelegate?.updateRemaingTimeUIAtIndex(index)
    }
    
    func timerStateDidChanged(updatedTimer: Timer, newState: TimerState) -> Void {
        let index = self.timersArray.indexOf(updatedTimer)!
        
        self.viewControllerDelegate?.updateTimerStateUIAtIndex(index)
    }
    
}
