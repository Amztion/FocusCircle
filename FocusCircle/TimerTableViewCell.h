//
//  TimerTableViewCell.h
//  FocusCircle
//
//  Created by Liang Zhao on 15/6/15.
//  Copyright © 2015年 Liang Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimerButton.h"
#import "TimerController.h"

@interface TimerTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *durationTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleOfTimerLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastUsedTime;


@property (weak, nonatomic) IBOutlet TimerButton *timerButtonView;


@end
