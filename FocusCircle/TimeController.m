//
//  TimeController.m
//  FocusCircle
//
//  Created by Liang Zhao on 15/6/23.
//  Copyright © 2015年 Liang Zhao. All rights reserved.
//

#import "TimeController.h"

@implementation TimeController

-(instancetype)initWithDurationTime:(NSNumber *)durationTime{
    self = [super init];
    if (self) {
        self.durationTime = durationTime;
        self.remainingTime = durationTime;
        self.status = TimerStopped;
    }
    return self;
}

@end
