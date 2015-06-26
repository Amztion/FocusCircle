//
//  NSDate+FCExtension.h
//  FocusCircle
//
//  Created by Liang Zhao on 15/6/24.
//  Copyright © 2015年 Liang Zhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (FCExtension)

+(NSDate *)getCurrentTimeInCurrentTimeZone;
-(NSString *)displayDateWithFormateInCurrentTimeZone;


@end