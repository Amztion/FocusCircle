//
//  PomodoroViewController.m
//  FocusCircle
//
//  Created by Liang Zhao on 15/6/30.
//  Copyright © 2015年 Liang Zhao. All rights reserved.
//

#import "PomodoroViewController.h"

@interface PomodoroViewController ()

@property (weak, nonatomic) IBOutlet Pomodoro *pomodoroButtonView;
@property (weak, nonatomic) IBOutlet UITextField *taskNameLabel;

@end

@implementation PomodoroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pomodoroButtonViewTapped:)];
    [tapGestureRecognizer setNumberOfTapsRequired:1];
    [self.pomodoroButtonView addGestureRecognizer:tapGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


- (void)pomodoroButtonViewTapped:(id)sender{
    
}

-(void)createPomodoro{
    
}

-(void)countdownPomodoro{
    
}


-(void)stopPomodoro{
    
}




@end
