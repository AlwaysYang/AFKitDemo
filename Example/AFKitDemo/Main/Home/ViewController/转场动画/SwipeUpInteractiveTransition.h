//
//  SwipeUpInteractiveTransition.h
//  AFKitDemo
//
//  Created by zws on 2017/12/12.
//  Copyright © 2017年 AF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwipeUpInteractiveTransition : UIPercentDrivenInteractiveTransition

//是否处于切换过程中 这个布尔值将在监测到手势开始时被设置，我们之后会在调用返回这个InteractiveTransition的时候用到
@property (nonatomic, assign) BOOL interacting;
- (void)wireToViewController:(UIViewController*)viewController;
@property (nonatomic, assign) BOOL shouldComplete;
@property (nonatomic, strong) UIViewController *presentingVC;
@end
