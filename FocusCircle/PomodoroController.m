//
//  PomodoroController.m
//  FocusCircle
//
//  Created by Liang Zhao on 15/7/1.
//  Copyright © 2015年 Liang Zhao. All rights reserved.
//

#import "PomodoroController.h"

@implementation PomodoroController

-(id)initWithWorkingTime:(NSNumber *)workingTime andBreakTime:(NSNumber *)breakTime andAmountOfRounds:(NSInteger)amountOfRounds{
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

@end
