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

class Timer: TimerModel, TimerControlProtocol {
    
    private var timer: NSTimer?
    var callback: ((timer: TimerModel) -> Void)?
    
    init?(dictionary: NSDictionary) {
        
    }
    
    
    
    //MARK: TimerControlProtocol
    func start() -> Bool {

        state = TimerState.Running
        
        return false
    }
    
    func pause() -> Bool {
        
        return false
    }
    
    func stop() -> Bool {
        
        return false
    }
    
    
}
