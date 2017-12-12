//
//  RuntimeViewController.m
//  AFKitDemo
//
//  Created by zws on 2017/12/11.
//  Copyright © 2017年 AF. All rights reserved.
//

#import "RuntimeViewController.h"
#import "UIButton+runtime.h"
@interface RuntimeViewController ()

@end

@implementation RuntimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //第一个按钮
    UIButton *button1 = [UIButton createBtnWithFrame:CGRectMake((ScreenWidth - 100)/2, (ScreenHeight - 50)/2 - 50, 100, 50) title:@"按钮" actionBlock:^(UIButton *button) {
        self.view.backgroundColor = RandomColor;
    }];
    button1.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:button1];
    
    //第二个按钮
    UIButton *button2 = [UIButton createBtnWithFrame:CGRectMake((ScreenWidth - 100)/2, CGRectGetMaxY(button1.frame) + 50, 100, 50) title:@"按钮2" actionBlock:nil];
    button2.actionBlock = ^(UIButton *button){
        NSLog(@"---%@---",button.currentTitle);
    };
    button2.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:button2];

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
