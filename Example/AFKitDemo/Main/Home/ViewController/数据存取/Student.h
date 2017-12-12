//
//  Student.h
//  AFKitDemo
//
//  Created by zws on 2017/12/11.
//  Copyright © 2017年 AF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Student : NSObject <NSCoding>
/**名字*/
@property (nonatomic,copy)NSString * name;
/** 年龄*/
@property (nonatomic,assign)NSInteger age;
@end
