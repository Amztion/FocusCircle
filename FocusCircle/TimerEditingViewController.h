//
//  TimerEditingViewController.h
//  FocusCircle
//
//  Created by Liang Zhao on 15/6/15.
//  Copyright © 2015年 Liang Zhao. All rights reserved.
//

#import "TimerTextInputViewController.h"

@interface TimerEditingViewController : TimerTextInputViewController

-(void)setValueForFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController forTimerIndexPath: (NSIndexPath *)indexPath;

@end
