//
//  ItemsNavigationController.h
//  FocusCircle
//
//  Created by Liang Zhao on 15/5/29.
//  Copyright (c) 2015年 Liang Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface ItemsNavigationController : UINavigationController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
