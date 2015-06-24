//
//  TimeController.h
//  FocusCircle
//
//  Created by Liang Zhao on 15/6/23.
//  Copyright © 2015年 Liang Zhao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    TimerStopped = 0,
    TimerPausing,
    TimerRunning
}Status;

@interface TimeController : NSObject

@property (strong, nonatomic) NSDate *startTime;
@property (strong, nonatomic) NSNumber *remainingTime;
@property (strong, nonatomic) NSNumber *durationTime;
@property (weak, nonatomic) NSTimer *timer;
@property (nonatomic) Status status;


-(instancetype)initWithDurationTime:(NSNumber *)durationTime;

@end
