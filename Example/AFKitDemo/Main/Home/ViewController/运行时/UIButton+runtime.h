//
//  UIButton+runtime.h
//  AFKitDemo
//
//  Created by zws on 2017/12/11.
//  Copyright © 2017年 AF. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ActionBlock)(UIButton *button);

@interface UIButton (runtime)

@property (nonatomic,copy) ActionBlock actionBlock;

+ (UIButton *)ButtonWithFrame:(CGRect)frame title:(NSString *)title actionBlock:(ActionBlock)actionBlock;

@end
