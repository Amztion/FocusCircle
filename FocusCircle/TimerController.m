//
//  TimerController.m
//  FocusCircle
//
//  Created by Liang Zhao on 15/6/25.
//  Copyright © 2015年 Liang Zhao. All rights reserved.
//

#import "TimerController.h"
#import "TimerModel.h"

@implementation TimerController

-(id)initWithDurationTime:(NSNumber *)durationTime andTimerModel:(TimerModel *)relatedTimerModel{
    self = [super init];
    if (self) {
        _remainingTime = [durationTime copy];
        _currentStatus = TimerStopped;
        _relatedTimerModel = relatedTimerModel;
        _durationTime = [durationTime copy];
    }
    return self;
}

-(void)attachTimer:(NSTimer *)timer isRestored:(BOOL)restored{
    if (!restored) {
        _currentStatus = TimerRunning;
        _startedTime = [NSDate date];
    }
    _timer = timer;
    [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSDefaultRunLoopMode];
    [_timer fire];
}

-(void)pauserTimer{
    _currentStatus = TimerPausing;
    [_timer setFireDate:[NSDate distantFuture]];
}

-(void)resumeTimer{
    _currentStatus = TimerRunning;
    NSDate *shouldEndTime = [[NSDate date]dateByAddingTimeInterval:_remainingTime.doubleValue];
    
    NSTimeInterval shouldendTimeInSecond = [shouldEndTime timeIntervalSince1970];
    NSTimeInterval durationTimeInSecond = _durationTime.doubleValue;
    
    _startedTime = [NSDate dateWithTimeIntervalSince1970:shouldendTimeInSecond - durationTimeInSecond];
    
    [_timer setFireDate:[NSDate distantPast]];
}

-(void)stopTimerForNormal:(BOOL)normal{
    if (normal) {
        [_relatedTimerModel setValue:[NSDate date] forKey:@"lastUsedTime"];
    }
    [_timer invalidate];
    _timer = nil;
    
    _currentStatus = TimerStopped;
    _remainingTime = _durationTime;
    
    _indexPath = nil;
    
}



@end
