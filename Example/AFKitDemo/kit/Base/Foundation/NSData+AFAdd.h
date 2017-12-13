//
//  NSData+AFAdd.h
//  AFKitDemo
//
//  Created by 猪卫士 on 16/11/9.
//  Copyright © 2016年 AF. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface NSData (AFAdd)
/**
 Returns a lowercase NSString for md5 hash.
 */
- (NSString *)md5String;

/**
 Returns a lowercase NSString for sha1 hash.
 */
- (NSString *)sha1String;


#pragma mark - Encode and decode

/**
 Returns string decoded in UTF8.
 */
- (nullable NSString *)utf8String;

/**
 Returns an NSDictionary or NSArray for decoded self.
 Returns nil if an error occurs.
 */
- (nullable id)jsonValueDecoded;
@end
NS_ASSUME_NONNULL_END
