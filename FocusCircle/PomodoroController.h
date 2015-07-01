//
//  PomodoroController.h
//  FocusCircle
//
//  Created by Liang Zhao on 15/7/1.
//  Copyright © 2015年 Liang Zhao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    PomodoroWorking = 0,
    PomodoroBreak,
    PomodoroStopped
}PomodoroStatus;

@interface PomodoroController : NSObject

@property (strong, nonatomic) NSNumber *workingTime;
@property (copy, nonatomic) NSNumber *workingRemaingTime;

@property (strong, nonatomic) NSNumber *breakTime;
@property (copy, nonatomic) NSNumber *breakRemaingTime;

@property (nonatomic) NSInteger amountOfRounds;
@property (nonatomic) NSInteger roundCounter;

@property (strong, nonatomic) NSTimer *timer;

@property (nonatomic) PomodoroStatus currentStatus;

-(id)initWithWorkingTime: (NSNumber *)workingTime andBreakTime: (NSNumber *)breakTime andAmountOfRounds: (NSInteger)amountOfRounds;

@end
