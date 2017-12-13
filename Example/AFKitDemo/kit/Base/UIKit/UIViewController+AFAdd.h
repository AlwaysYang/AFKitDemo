//
//  UIViewController+AFAdd.h
//  AFKitDemo
//
//  Created by 猪卫士 on 16/11/10.
//  Copyright © 2016年 AF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (AFAdd)

- (void)showHudInView:(UIView *)view hint:(NSString *)hint;

- (void)hideHud;

- (void)showHint:(NSString *)hint;

// 从默认(showHint:)显示的位置再往上(下)yOffset
- (void)showHint:(NSString *)hint yOffset:(float)yOffset;
@end
