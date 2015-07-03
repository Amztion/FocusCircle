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
@property (weak, nonatomic) IBOutlet UITextField *taskNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *pomodoroTimeLabel;

@property (strong, nonatomic) PomodoroController *pomodoroController;
@property (nonatomic) NSInteger todayRounds;

@end

@implementation PomodoroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pomodoroButtonViewTapped:)];
    [tapGestureRecognizer setNumberOfTapsRequired:1];
    self.pomodoroController = [[PomodoroController alloc]initWithWorkingTime:5 andBreakTime:5 andAmountOfRounds:4];
    [self.pomodoroButtonView addGestureRecognizer:tapGestureRecognizer];
    self.pomodoroTimeLabel.hidden = YES;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)pomodoroButtonViewTapped:(id)sender{
    if (self.pomodoroController.currentStatus == PomodoroStopped) {
        [self.pomodoroController startPomodoroWithTimer:[NSTimer timerWithTimeInterval:1 target:self selector:@selector(countdownPomodoro:) userInfo:nil repeats:YES]];
        self.taskNameTextField.hidden = YES;
        self.pomodoroTimeLabel.hidden = NO;
    }else{
        UIAlertController *stopAlert = [UIAlertController alertControllerWithTitle:@"停止番茄时钟" message:@"暂停将停止番茄时钟" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAlert = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *stopPomodoro = [UIAlertAction actionWithTitle:@"停止" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *alertAction){
            [self.pomodoroController stopPomodoro];
        }];
        
        [stopAlert addAction:cancelAlert];
        [stopAlert addAction:stopPomodoro];
        [self presentViewController:stopAlert animated:YES completion:nil];
        
    }
}

-(void)countdownPomodoro:(id)sender{
    switch (self.pomodoroController.currentStatus) {
        case PomodoroWorking:
            if (self.pomodoroController.workingRemaingTime > 0) {
                NSString *remaining = [NSString stringWithSeconds:[NSNumber numberWithDouble:self.pomodoroController.workingRemaingTime]];
                self.pomodoroTimeLabel.text = [NSString stringWithFormat:@"工作剩余：%@",remaining];
                [self.pomodoroTimeLabel sizeToFit];
                [self.view setNeedsLayout];
                self.pomodoroController.workingRemaingTime = self.pomodoroController.workingRemaingTime - 1;
            }else{
                [self.pomodoroController goToHaveBreak];
                self.pomodoroTimeLabel.text = [NSString stringWithFormat:@"工作剩余：00:00:00"];
            }
            break;
        case PomodoroBreak:
            if (self.pomodoroController.breakRemaingTime > 0) {
                NSString *remaining = [NSString stringWithSeconds:[NSNumber numberWithDouble:self.pomodoroController.breakRemaingTime]];
                self.pomodoroTimeLabel.text = [NSString stringWithFormat:@"休息剩余：%@",remaining];
                [self.pomodoroTimeLabel sizeToFit];
                self.pomodoroController.breakRemaingTime = self.pomodoroController.breakRemaingTime - 1;
            }else{
                if (self.pomodoroController.roundCounter == self.pomodoroController.amountOfRounds - 1) {
                    ++self.pomodoroController.roundCounter;
                    self.pomodoroTimeLabel.hidden = YES;
                    [self.pomodoroController stopPomodoro];
                }else{
                    [self.pomodoroController goToWork];
                    self.pomodoroTimeLabel.text = [NSString stringWithFormat:@"休息剩余：00:00:00"];
                }
                
            }
            
        default:
            break;
    }
    
}

@end
