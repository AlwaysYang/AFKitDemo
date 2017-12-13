//
//  NSString+AFAdd.m
//  AFKitDemo
//
//  Created by 猪卫士 on 16/11/9.
//  Copyright © 2016年 AF. All rights reserved.
//

#import "NSString+AFAdd.h"
#import "NSData+AFAdd.h"
#import "NSNumber+AFAdd.h"
@implementation NSString (AFAdd)

- (BOOL)isEmpty {
    if (self == nil) {
        return YES;
    }
    if ([self isEqualToString:@""]) {
        return YES;
    }
    if ([[NSString stringWithFormat:@"%@", self] isEqualToString:@"(null)"] ||
        [[NSString stringWithFormat:@"%@", self] isEqualToString:@"<null>"]) {
        return YES;
    }
    
    return NO;
}

- (NSString *)md5String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] md5String];
}

- (NSString *)sha1String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha1String];
}

- (CGSize)sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode {
    CGSize result;
    if (!font) font = [UIFont systemFontOfSize:12];
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableDictionary *attr = [NSMutableDictionary new];
        attr[NSFontAttributeName] = font;
        if (lineBreakMode != NSLineBreakByWordWrapping) {
            NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
            paragraphStyle.lineBreakMode = lineBreakMode;
            attr[NSParagraphStyleAttributeName] = paragraphStyle;
        }
        CGRect rect = [self boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:attr context:nil];
        result = rect.size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        result = [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
    }
    return result;
}

- (CGFloat)widthForFont:(UIFont *)font {
    CGSize size = [self sizeForFont:font size:CGSizeMake(HUGE, HUGE) mode:NSLineBreakByWordWrapping];
    return size.width;
}

- (CGFloat)heightForFont:(UIFont *)font width:(CGFloat)width {
    CGSize size = [self sizeForFont:font size:CGSizeMake(width, HUGE) mode:NSLineBreakByWordWrapping];
    return size.height;
}

+ (NSString *)stringWithUUID {
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return (__bridge_transfer NSString *)string;
}


- (NSString *)stringByTrim {
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [self stringByTrimmingCharactersInSet:set];
}

- (NSString *)replaceString:(NSString *)strOne byString:(NSString *)strTwo{
    if ([self  isEmpty]) {
        return @"";
    }
    NSArray *tempArr = [self componentsSeparatedByString:strOne];
    if (!tempArr) {
        return @"";
    }
    return [tempArr componentsJoinedByString:strTwo];
}

- (NSString *)disableEmojiString{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:self
                                                               options:0
                                                                 range:NSMakeRange(0, [self length])
                                                          withTemplate:@""];
    return modifiedString;
}

- (BOOL)isNotBlank {
    NSCharacterSet *blank = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for (NSInteger i = 0; i < self.length; ++i) {
        unichar c = [self characterAtIndex:i];
        if (![blank characterIsMember:c]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)containsString:(NSString *)string {
    if (string == nil) return NO;
    return [self rangeOfString:string].location != NSNotFound;
}



- (BOOL)isChineseString{
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isOneOfThem:(NSArray *)strings {
    
    if (strings.count == 0) {
        return NO;
    }
    
    for (id one in strings) {
        if ([one isKindOfClass:[NSString class]]) {
            if ([self isEqualToString:one]) {
                return YES;
            }
        } else {
            if ([self isEqualToString:[NSString stringWithFormat:@"%@", one]]) {
                return YES;
            }
        }
    }
    
    return NO;
}

- (BOOL)hasStringInThem:(NSArray *)strings{
    for (NSString *tempstr in strings) {
        if ([self rangeOfString:tempstr].location != NSNotFound) {
            return YES;
        }
    }
    return NO;
}


- (NSNumber *)numberValue {
    return [NSNumber numberWithString:self];
}

- (NSData *)dataValue {
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSRange)rangeOfAll {
    return NSMakeRange(0, self.length);
}

- (id)jsonValueDecoded {
    return [[self dataValue] jsonValueDecoded];
}

- (int)compareDatewithDate:(NSString*)compareDate{
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *dt1 = [[NSDate alloc] init];
    NSDate *dt2 = [[NSDate alloc] init];
    dt1 = [df dateFromString:self];
    dt2 = [df dateFromString:compareDate];
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending: ci=1; break;
            //date02比date01小
        case NSOrderedDescending: ci=-1; break;
            //date02=date01
        case NSOrderedSame: ci=0; break;
        default: NSLog(@"erorr dates %@, %@", dt2, dt1); break;
    }
    return ci;
}


- (NSDate *)dateWithFormat:(NSString *)fmtString andTimezone:(NSString *)timezoneName {
    
    if (self == nil || [self isEqualToString:@""] || fmtString == nil || [fmtString isEqualToString:@""]) {
        return nil;
    }
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = fmtString;
    
    if (timezoneName != nil && ![timezoneName isEqualToString:@""]) {
        fmt.timeZone = [NSTimeZone timeZoneWithName:timezoneName];
    }
    
    return [fmt dateFromString:self];
}

- (NSDate *)dateWithFormat:(NSString *)fmtString dateStyle:(NSDateFormatterStyle)style {
    
    if (self == nil || [self isEqualToString:@""] || fmtString == nil || [fmtString isEqualToString:@""]) {
        return nil;
    }
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    fmt.dateStyle = style;
    fmt.dateFormat = fmtString;
    
    return [fmt dateFromString:self];
}

@end
