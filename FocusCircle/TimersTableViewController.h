//
//  TimersTableViewController.h
//  FocusCircle
//
//  Created by Liang Zhao on 15/5/29.
//  Copyright (c) 2015年 Liang Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationController.h"
#import "TimerTableViewCell.h"
#import "TimerTextInputViewController.h"
#import "TimerEditingViewController.h"

#import "NSDate+FCExtension.h"
#import "NSString+FCExtension.h"

@interface TimersTableViewController : UITableViewController<NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
