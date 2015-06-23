//
//  ItemTableViewCell.h
//  FocusCircle
//
//  Created by Liang Zhao on 15/6/15.
//  Copyright © 2015年 Liang Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "timerButton.h"

@interface ItemTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *durationTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleOfItemLabel;
@property (weak, nonatomic) IBOutlet timerButton *timerButtonView;

@end
