//
//  ItemEditingViewController.h
//  FocusCircle
//
//  Created by Liang Zhao on 15/6/15.
//  Copyright © 2015年 Liang Zhao. All rights reserved.
//

#import "ItemTextInputViewController.h"

@interface ItemEditingViewController : ItemTextInputViewController

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) NSString *titleOfItem;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResulesController;

@property (nonatomic) NSNumber *hours;
@property (nonatomic) NSNumber *minutes;
@property (nonatomic) NSNumber *seconds;

@end
