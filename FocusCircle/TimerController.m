//
//  TimerController.m
//  FocusCircle
//
//  Created by Liang Zhao on 15/6/25.
//  Copyright © 2015年 Liang Zhao. All rights reserved.
//

#import "TimerController.h"

@implementation TimerController

-(id)initWithDurationTime:(NSNumber *)durationTime andTimerModel:(TimerModel *)relatedTimerModel{
    self = [super init];
    if (self) {
        self.remainingTime = [durationTime copy];
        self.currentStatus = TimerStopped;
        self.relatedTimerModel = relatedTimerModel;
        self.durationTime = [durationTime copy];
    }
    return self;
}



@end
