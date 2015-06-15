//
//  ItemModel+CoreDataProperties.h
//  FocusCircle
//
//  Created by Liang Zhao on 15/6/15.
//  Copyright © 2015年 Liang Zhao. All rights reserved.
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

#import "ItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ItemModel (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *duration;
@property (nullable, nonatomic, retain) NSDate *lastUsedTime;
@property (nullable, nonatomic, retain) NSString *titleOfItem;

@end

NS_ASSUME_NONNULL_END