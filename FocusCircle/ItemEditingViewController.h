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


-(void)setValueForTimes:(NSNumber *)time;

@end
