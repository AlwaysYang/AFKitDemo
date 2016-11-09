//
//  NSNumber+AFAdd.h
//  AFKitDemo
//
//  Created by 猪卫士 on 16/11/9.
//  Copyright © 2016年 AF. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSNumber (AFAdd)
/**
 Creates and returns an NSNumber object from a string.
 Valid format: @"12", @"12.345", @" -0xFF", @" .23e99 "...
 
 @param string  The string described an number.
 
 @return an NSNumber when parse succeed, or nil if an error occurs.
 */
+ (nullable NSNumber *)numberWithString:(NSString *)string;
@end

NS_ASSUME_NONNULL_END
