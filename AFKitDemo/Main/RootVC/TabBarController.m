//
//  TabBarController.m
//  PullWires
//
//  Created by ZWS on 17/6/8.
//  Copyright © 2017年 AF. All rights reserved.
//

#import "TabBarController.h"
#import "BaseNavigationController.h"
#import "HomeViewController.h"
#import "FindViewController.h"
#import "ViewController.h"
@interface TabBarController ()<UITabBarControllerDelegate>

@end

@implementation TabBarController{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    [self createChildView];
}

- (void)createChildView{
    UINavigationController *homeNav = [[BaseNavigationController alloc] initWithRootViewController:[[HomeViewController alloc] init]];
    
    UINavigationController *findNav = [[BaseNavigationController alloc] initWithRootViewController:[[FindViewController alloc] init]];
    
    UINavigationController *otherNav = [[BaseNavigationController alloc] initWithRootViewController:[[ViewController alloc] init]];
    NSArray *tabNames = @[@"首页",@"发现",@"test"];
    
    [self setViewControllers:@[homeNav,findNav,otherNav]];
    
    int i = 0;
    for (UINavigationController *navC in self.viewControllers) {
        navC.title = tabNames[i];
        i ++;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    
    return YES;
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
