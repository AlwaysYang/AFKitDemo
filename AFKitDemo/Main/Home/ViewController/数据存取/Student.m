//
//  Student.m
//  AFKitDemo
//
//  Created by zws on 2017/12/11.
//  Copyright © 2017年 AF. All rights reserved.
//

#import "Student.h"

@implementation Student

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"student.name"];
        self.age = [aDecoder decodeIntegerForKey:@"student.age"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder{
    [coder encodeObject:self.name forKey:@"student.name"];
    [coder encodeInteger:self.age forKey:@"student.age"];
}

@end
