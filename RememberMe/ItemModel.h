//
//  ItemModel.h
//  RememberMe
//
//  Created by Liang Zhao on 15/5/29.
//  Copyright (c) 2015年 Liang Zhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemModel : NSObject

@property (strong, nonatomic) NSString *itemName;
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSString *currentRate;

- (void) editItemName: (NSString *)newName;
- (BOOL) checkStatus: (NSDate *)currentDate;
- (BOOL) finishItem: (NSDate *)currentDate;

@end
