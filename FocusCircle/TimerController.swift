//
//  TimerController.swift
//  FocusCircle
//
//  Created by Liang Zhao on 16/1/9.
//  Copyright © 2016年 Liang Zhao. All rights reserved.
//

import UIKit

protocol TimerUpdateProtocol {
    var identifier: String { get }
    
    func updateTimerUIAtIndex(index: Int)
}

class TimerController {
    
    static let sharedController = TimerController()
    
    private var timerModelsArray = [TimerModel]()
    private var viewControllerObservers = [String: TimerUpdateProtocol]()
    
    func registerObserver(observer: TimerUpdateProtocol) {
        
        if !viewControllerObservers.keys.contains(observer.identifier) {
            viewControllerObservers.updateValue(observer, forKey: observer.identifier)
        }
    }
    
    func unregisterObserver(observer: TimerUpdateProtocol) {
        if viewControllerObservers.keys.contains(observer.identifier) {
            viewControllerObservers.removeValueForKey(observer.identifier)
        }
    }
    
    //Get Timers Info
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
    
    
    //Storage
    private func restoreTimersFromDataBase() {
        
        //Read From Database
        let fakeDatabaseDict = Dictionary<String, String>()
        
        let timerModel: TimerModel = Timer(dictionary: fakeDatabaseDict)
        
        
        
        timerModelsArray.append(timerModel)
    }
    
    private func saveTimerToDatabase() {
        
    }
    
}
