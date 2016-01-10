//
//  TimerController.swift
//  FocusCircle
//
//  Created by Liang Zhao on 16/1/9.
//  Copyright © 2016年 Liang Zhao. All rights reserved.
//

import UIKit

protocol TimerUpdateProtocol {
    func updateTimerUIAtIndex(index: Int)
}

class TimerController {

    static var sharedController = TimerController()
    var viewControllerDelegate: TimerUpdateProtocol?
    
    private var timerModelsArray = [TimerModel]()
    
    //MARK: Get Timers Info
    func numbersOfTimers() -> Int {
        return timerModelsArray.count
    }
    
    func timerModelAtIndex(index: Int) -> TimerModel? {
        if index >= timerModelsArray.count {
            return nil
        }else{
            return timerModelsArray[index]
        }
    }
    
    //MARK: Storage
    private func restoreTimersFromDataBase() {
        
        //Read From Database
        let fakeDatabaseDict = Dictionary<String, String>()
        
        let timerModel = Timer(dictionary: fakeDatabaseDict)

        if let timerModelToHandle = timerModel {
            timerModelToHandle.callback! = {
                updatedTimerModel in
                let index = self.timerModelsArray.indexOf(updatedTimerModel)
                
                self.viewControllerDelegate?.updateTimerUIAtIndex(index!)
            }
            
            timerModelsArray.append(timerModelToHandle)
        }
    }
    
    private func saveTimerToDatabase() {
        
    }
    
}
