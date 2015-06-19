//
//  ItemsTableViewController.h
//  FocusCircle
//
//  Created by Liang Zhao on 15/5/29.
//  Copyright (c) 2015年 Liang Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ItemTableViewCell.h"

@interface ItemsTableViewController : UITableViewController<NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

-(void)setNeedUpdateData:(BOOL)needUpdateData;

@end
