//
//  ItemModel.h
//  FocusCircle
//
//  Created by Liang Zhao on 15/5/29.
//  Copyright (c) 2015年 Liang Zhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemModel : NSObject

@property (strong, nonatomic) NSString *titleOfItem;
@property (nonatomic) double duration;
@property (strong, nonatomic) NSDate *lastUsedTime;


@end
