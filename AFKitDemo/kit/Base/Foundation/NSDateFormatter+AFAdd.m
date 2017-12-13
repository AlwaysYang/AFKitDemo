//
//  NSDateFormatter+AFAdd.m
//  AFKitDemo
//
//  Created by 猪卫士 on 16/11/10.
//  Copyright © 2016年 AF. All rights reserved.
//

#import "NSDateFormatter+AFAdd.h"

@implementation NSDateFormatter (AFAdd)
+ (id)dateFormatter
{
    return [[self alloc] init];
}

+ (id)dateFormatterWithFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[self alloc] init];
    dateFormatter.dateFormat = dateFormat;
    return dateFormatter;
}

+ (id)defaultDateFormatter
{
    return [self dateFormatterWithFormat:@"yyyy-MM-dd HH:mm:ss"];
}
@end
