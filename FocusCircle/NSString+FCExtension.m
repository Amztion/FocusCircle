//
//  NSString+FCExtension.m
//  FocusCircle
//
//  Created by Liang Zhao on 15/6/24.
//  Copyright © 2015年 Liang Zhao. All rights reserved.
//

#import "NSString+FCExtension.h"

@implementation NSString (FCExtension)

+(NSString *)stringWithSeconds:(NSNumber *)time{
    NSInteger hours = time.integerValue/3600;
    NSInteger minutes = time.integerValue/60%60;
    NSInteger seconds = time.integerValue%3600 - minutes*60;
    
    NSString *string = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds];
    return string;
}

@end