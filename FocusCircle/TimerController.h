//
//  TimerController.h
//  FocusCircle
//
//  Created by Liang Zhao on 15/6/25.
//  Copyright © 2015年 Liang Zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "TimerModel.h"
@class TimerModel;


typedef enum{
    TimerStopped = 0,
    TimerPausing,
    TimerRunning
}Status;


@interface TimerController : NSObject

@property (copy, nonatomic) NSNumber *remainingTime;
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) Status currentStatus;
@property (strong, nonatomic) NSDate *startedTime;
@property (strong, nonatomic) NSIndexPath *indexPath;


//-(instancetype)initWithTimerModel: (TimerModel *)timerModel;

-(id)initWithDurationTime: (NSNumber *)durationTime;

@end
