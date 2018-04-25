//
//  GSBlurViewController.m
//  AFKitDemo
//
//  Created by zws on 2017/12/15.
//  Copyright © 2017年 AF. All rights reserved.
//

#import "GSBlurViewController.h"
#import "FXBlurView.h"
@interface GSBlurViewController ()
/** 模糊试图*/
@property (nonatomic,strong)FXBlurView * blurView;
@end

@implementation GSBlurViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    UIImageView *imageView = [[UIImageView alloc] init];
    
    //    imageView.image = [[UIImage imageNamed:@"timg.jpeg"] blurredImageWithRadius:90.f iterations:1 tintColor:[UIColor redColor]];
    imageView.image = [UIImage imageNamed:@"timg.jpeg"];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
        } else {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }
    }];
   
    _blurView = [[FXBlurView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_blurView];
    [_blurView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
        } else {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }
    }];
    
    NSString *type = nil;
    if (type == 0) {
        
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
