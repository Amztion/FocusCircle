//
//  TimerModel.m
//  FocusCircle
//
//  Created by Liang Zhao on 15/6/25.
//  Copyright © 2015年 Liang Zhao. All rights reserved.
//

#import "TimerModel.h"

@implementation TimerModel

@synthesize timerController;

-(TimerController *)timerController{
    if (timerController) {
        return timerController;
    }else{
        timerController = [[TimerController alloc]initWithDurationTime:self.durationTime andTimerModel:self];
        return timerController;
    }
}

@end
