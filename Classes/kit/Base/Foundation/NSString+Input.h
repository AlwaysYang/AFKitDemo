//
//  NSString+Input.h
//  AFKitDemo
//
//  Created by 猪卫士 on 16/11/9.
//  Copyright © 2016年 AF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Input)

- (BOOL)isEqualWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2);

- (BOOL)isEmail;

- (BOOL)isPhoneNumber;

#pragma mark EMOJI

- (NSString *)replaceEmojiTextWithUnicode;

- (NSString *)replaceEmojiUnicodeWithText;

@end
