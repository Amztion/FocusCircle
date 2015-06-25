//
//  TimerModel+CoreDataProperties.h
//  FocusCircle
//
//  Created by Liang Zhao on 15/6/25.
//  Copyright © 2015年 Liang Zhao. All rights reserved.
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

#import "TimerModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TimerModel (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *durationTime;
@property (nullable, nonatomic, retain) NSDate *lastUsedTime;
@property (nullable, nonatomic, retain) NSNumber *sortValue;
@property (nullable, nonatomic, retain) NSString *titleOfTimer;

@end

NS_ASSUME_NONNULL_END
