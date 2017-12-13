//
//  ViewController.m
//  AFTempProject
//
//  Created by ZWS on 17/9/5.
//  Copyright © 2017年 AF. All rights reserved.
//

#import "ViewController.h"
#import "UIButton+runtime.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = RandomColor;
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        [self setEdgesForExtendedLayout: UIRectEdgeNone];
    }
    
    //返回按钮
    __weak typeof(self)weakSelf = self;
    UIButton *button = [UIButton ButtonWithFrame:CGRectZero title:@"dismiss" actionBlock:^(UIButton *button) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf dismissViewControllerAnimated:YES completion:nil];
    }];
    [self.view addSubview:button];
    button.frame = CGRectMake(0, 0, 100, 100);
    button.center = self.view.center;
    [button setBackgroundColor:RandomColor];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
