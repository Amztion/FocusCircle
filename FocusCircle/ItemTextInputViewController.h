//
//  ItemTextInputViewController.h
//  FocusCircle
//
//  Created by Liang Zhao on 15/5/29.
//  Copyright (c) 2015年 Liang Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemsTableViewController.h"
#import "AppDelegate.h"

@interface ItemTextInputViewController : UITableViewController

@property (strong, nonatomic) NSString *titleOfItem;
@property (strong,nonatomic) NSString *duration;
@property (strong, nonatomic) NSString *createDate;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
