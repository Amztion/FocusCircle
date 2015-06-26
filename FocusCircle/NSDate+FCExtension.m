//
//  NSDate+FCExtension.m
//  FocusCircle
//
//  Created by Liang Zhao on 15/6/24.
//  Copyright © 2015年 Liang Zhao. All rights reserved.
//

#import "NSDate+FCExtension.h"

@implementation NSDate (FCExtension)

+(NSDate*)getCurrentTimeInCurrentTimeZone{
    NSDate *nowTimeInGMT = [NSDate date];
    NSTimeZone *currentTimeZone = [NSTimeZone systemTimeZone];
    NSInteger seconds = [currentTimeZone secondsFromGMTForDate:nowTimeInGMT];
    NSDate *localTimeNow = [nowTimeInGMT dateByAddingTimeInterval:seconds];
    
    return localTimeNow;
}

-(NSString *)displayDateWithFormateInCurrentTimeZone{
    NSDate *dateToDisplay = self;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    dateFormatter.timeZone = [NSTimeZone localTimeZone];

    return [dateFormatter stringFromDate:dateToDisplay];
}

@end
