//
//  TimerController.h
//  FocusCircle
//
//  Created by Liang Zhao on 15/6/25.
//  Copyright © 2015年 Liang Zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimerModel.h"


typedef enum{
    TimerStopped = 0,
    TimerPausing,
    TimerRunning
}Status;


@interface TimerController : NSObject

@property (copy, nonatomic) NSNumber *remainingTime;
@property (strong, nonatomic) NSNumber *durationTime;
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) Status currentStatus;
@property (strong, nonatomic) TimerModel *relatedTimerModel;

-(instancetype)initWithTimerModel: (TimerModel *)timerModel;

@end
