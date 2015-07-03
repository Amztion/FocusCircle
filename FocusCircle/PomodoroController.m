//
//  PomodoroController.m
//  FocusCircle
//
//  Created by Liang Zhao on 15/7/1.
//  Copyright © 2015年 Liang Zhao. All rights reserved.
//

#import "PomodoroController.h"

@implementation PomodoroController

-(id)initWithWorkingTime:(NSTimeInterval)workingTime andBreakTime:(NSTimeInterval)breakTime andAmountOfRounds:(NSInteger)amountOfRounds{
    self = [super init];
    if (self) {
        _workingTime = workingTime;
        _workingRemaingTime = workingTime;
        
        _breakTime = breakTime;
        _breakRemaingTime = breakTime;
        
        _amountOfRounds = amountOfRounds;
        _roundCounter = 0;
        
        _currentStatus = PomodoroStopped;
    }
    return self;
}

-(void)startPomodoroWithTimer:(NSTimer *)timer{
    _timer = timer;
    _currentStatus = PomodoroWorking;
    [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSDefaultRunLoopMode];
    [_timer fire];
}

-(void)stopPomodoro{
    [_timer invalidate];
    _timer = nil;
    _currentStatus = PomodoroStopped;
    _workingRemaingTime = _workingTime;
    _breakRemaingTime = _breakTime;
}


-(void)goToWork{
    _currentStatus = PomodoroWorking;
    _breakRemaingTime = _breakTime;
}

-(void)goToHaveBreak{
    _currentStatus = PomodoroBreak;
    _workingRemaingTime = _workingTime;
    ++ _roundCounter;
}

@end
