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

@property (nonatomic) NSTimeInterval workingTime;
@property (nonatomic) NSTimeInterval workingRemaingTime;

@property (nonatomic) NSTimeInterval breakTime;
@property (nonatomic) NSTimeInterval breakRemaingTime;

@property (nonatomic) NSInteger amountOfRounds;
@property (nonatomic) NSInteger roundCounter;

@property (strong, nonatomic) NSTimer *timer;

@property (nonatomic) PomodoroStatus currentStatus;

-(id)initWithWorkingTime: (NSTimeInterval)workingTime andBreakTime: (NSTimeInterval)breakTime andAmountOfRounds: (NSInteger)amountOfRounds;

-(void)startPomodoroWithTimer: (NSTimer *)timer;

-(void)stopPomodoro;

-(void)goToHaveBreak;

-(void)goToWork;

@end
