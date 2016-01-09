//
//  TimerController.swift
//  FocusCircle
//
//  Created by Liang Zhao on 16/1/9.
//  Copyright © 2016年 Liang Zhao. All rights reserved.
//

import UIKit

protocol TimerUpdateProtocol {
    
}

class TimerController {
    
    static let sharedController = TimerController()
    
    var timers = [Timer]()
    var viewControllerObservers = [TimerUpdateProtocol]()
    
    func registerObserver(observer: TimerUpdateProtocol) {
        
        viewControllerObservers.append(observer)
        
        viewControllerObservers.contains() { (observer) -> Bool in
            return true
        }
        
    }
    
    func unregisterObserver(observer: TimerUpdateProtocol) {
        
        
        
    }
    
    
    
    
    
}
