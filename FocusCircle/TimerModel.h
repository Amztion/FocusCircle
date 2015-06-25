//
//  TimerModel.h
//  FocusCircle
//
//  Created by Liang Zhao on 15/6/25.
//  Copyright © 2015年 Liang Zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "TimerController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TimerModel : NSManagedObject

@property (readonly) TimerController *timerController;


@end

NS_ASSUME_NONNULL_END

#import "TimerModel+CoreDataProperties.h"
