//
//  TimerController.h
//  FocusCircle
//
//  Created by Liang Zhao on 15/6/25.
//  Copyright © 2015年 Liang Zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TimerModel;

typedef enum{
    TimerStopped = 0,
    TimerPausing,
    TimerRunning
}Status;


@interface TimerController : NSObject

@property (copy, nonatomic) NSNumber *remainingTime;
@property (weak, nonatomic) NSTimer *timer;
@property (nonatomic) Status currentStatus;
@property (strong, nonatomic) NSDate *startedTime;
@property (copy, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) TimerModel *relatedTimerModel;
@property (nonatomic, getter=isEnterBackground) BOOL enterBackground;


-(id)initWithDurationTime: (NSNumber *)durationTime andTimerModel: (TimerModel *)relatedTimerModel;

@end
