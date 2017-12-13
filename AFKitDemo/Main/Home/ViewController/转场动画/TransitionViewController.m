//
//  TransitionViewController.m
//  AFKitDemo
//
//  Created by zws on 2017/10/19.
//  Copyright © 2017年 AF. All rights reserved.
//

#import "TransitionViewController.h"
#import "UIButton+runtime.h"
#import "ViewController.h"
#import "BouncePresentAnimation.h"
#import "BounceDismissAnimation.h"
#import "SwipeUpInteractiveTransition.h"

@interface TransitionViewController ()<UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) BouncePresentAnimation *presentAnimation;
@property (nonatomic, strong) BounceDismissAnimation *dismissAnimation;
@property (nonatomic, strong) SwipeUpInteractiveTransition *transitionController;
@end

@implementation TransitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self af_setViewBackgroundColor:[UIColor whiteColor]];
    NSArray *buttons = @[@{@"name":@"pop",},
                         @{@"name":@"present系统"},
                         @{@"name":@"present自定义"}
                         ];
    NSInteger col = 3;//
    CGFloat margin = 20;
    CGFloat viewW = (ScreenWidth - (col - 1) * margin) / col;
    CGFloat viewH = viewW;
    for (int i = 0; i < buttons.count; i ++) {
        NSInteger index = i;//
        CGFloat viewX = (index % col ) * (viewW + margin);
        CGFloat viewY = (index / col ) * (viewH + 10);
        __weak typeof(self)weakSelf = self;
        UIButton *button = [UIButton ButtonWithFrame:CGRectMake(viewX, viewY, viewW, viewH) title:buttons[i][@"name"] actionBlock:^(UIButton *button) {
            switch (i) {
                case 0:
                {
                    [weakSelf.navigationController pushViewController:[[ViewController alloc] init] animated:YES];
                }
                    
                    break;
                case 1:
                {
                    ViewController *presentedVC = [[ViewController alloc] init];
                    //                - UIModalTransitionStyleCoverVertical :从下方弹出
                    //                - UIModalTransitionStyleFlipHorizontal :翻转跳转
                    //                - UIModalTransitionStyleCrossDissolve :渐变出现
                    //                - UIModalTransitionStylePartialCurl : 翻页效果
                    presentedVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal; //默认样式
                    [weakSelf presentViewController:presentedVC animated:YES completion:nil];
                }
                    
                case 2:
                {
                    _presentAnimation = [[BouncePresentAnimation alloc] init];
                    _dismissAnimation = [[BounceDismissAnimation alloc] init];
                    _transitionController = [SwipeUpInteractiveTransition new];
                    ViewController *presentedVC = [[ViewController alloc] init];
                    presentedVC.transitioningDelegate = self;
                    presentedVC.modalPresentationStyle = UIModalPresentationCustom;
                    [weakSelf presentViewController:presentedVC animated:YES completion:nil];
                    [weakSelf.transitionController wireToViewController:presentedVC];
                }
                    
                    
                default:
                    break;
            }
        }];
        [button setBackgroundColor:RandomColor];
        [self.view addSubview:button];
    }
}


#pragma mark ---UIViewControllerTransitioningDelegate---

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return _presentAnimation;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return _dismissAnimation;
}

-(id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    return self.transitionController.interacting ? self.transitionController : nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
