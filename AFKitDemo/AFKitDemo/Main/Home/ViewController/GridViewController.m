//
//  GridViewController.m
//  AFKitDemo
//
//  Created by ZWS on 17/9/6.
//  Copyright © 2017年 AF. All rights reserved.
//

#import "GridViewController.h"

@interface GridViewController ()

@end

@implementation GridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createGird];
}
- (void)createGird{
    NSInteger col = 3;//
    CGFloat margin = 20;
    CGFloat viewW = (ScreenWidth - (col - 1) * margin) / col;
    CGFloat viewH = viewW;
    for (int i = 0; i < 7; i ++) {
        NSInteger index = i;//
        CGFloat viewX = (index % col ) * (viewW + margin);
        NSLog(@"----%ld",(index % col ));
        CGFloat viewY = (index / col ) * (viewH + 10);
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(viewX, viewY, viewW, viewH)];
        view.backgroundColor = [UIColor brownColor];
        [self.view addSubview:view];
    }
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
