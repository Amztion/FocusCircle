//
//  TimerController.m
//  FocusCircle
//
//  Created by Liang Zhao on 15/6/25.
//  Copyright © 2015年 Liang Zhao. All rights reserved.
//

#import "TimerController.h"

@implementation TimerController

//-(instancetype)initWithTimerModel:(TimerModel *)timerModel{
//    self = [super init];
//    if(self){
//        self.relatedTimerModel = timerModel;
//        self.durationTime = timerModel.durationTime;
//        self.remainingTime = timerModel.durationTime;
//        self.currentStatus = TimerStopped;
//    }
//    return self;
//}

-(id)initWithDurationTime:(NSNumber *)durationTime{
    self = [super init];
    if (self) {
        self.remainingTime = durationTime;
        self.currentStatus = TimerStopped;
    }
    return self;
}

@end
