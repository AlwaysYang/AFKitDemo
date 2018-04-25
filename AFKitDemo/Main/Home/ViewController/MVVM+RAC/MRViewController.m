//
//  MRViewController.m
//  AFKitDemo
//
//  Created by zws on 2017/12/13.
//  Copyright © 2017年 AF. All rights reserved.
//

#import "MRViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "UIView+YYAdd.h"
@interface MRViewController ()
/** viewq*/
@property (nonatomic,strong)UILabel * view1;
@property (nonatomic,strong)UILabel * view2;
@end

@implementation MRViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    // 创建一个信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        // 发送信号
        [subscriber sendNext:@"发送一个信号"];
        return nil;
    }];
    
    // 订阅一个信号
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"接收内容：%@",x);
    }];
    
//    [self UIImagePickerController];
    
    UILabel *view1 = [[UILabel alloc] init];
    [self.view addSubview:view1];
    [view1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@100);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(80, 60));
    }];
    
    UILabel *view2 = [[UILabel alloc] init];
    [self.view addSubview:view2];
    [view2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@100);
        make.right.equalTo(@(-10));
        make.left.equalTo(view1.mas_right).offset(10);
        make.height.equalTo(view1);
    }];
    view1.backgroundColor = RandomColor;
    view2.backgroundColor = RandomColor;
    _view1 = view1;
    _view2 = view2;
   
    UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@500);
        make.right.equalTo(@(-10));
        make.size.mas_equalTo(CGSizeMake(80, 60));
    }];
    [button setBackgroundColor:RandomColor];
    [button addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
}

- (void)action{
    [_view1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@200);
    }];
    [_view2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(_view1.mas_height).offset(100);
    }];
//    [_view2 mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(@100);
//        make.right.equalTo(@(-10));
//        make.left.equalTo(_view1.mas_right).offset(10);
//        make.height.equalTo(_view1);
//    }];
//    [UIView animateWithDuration:2 animations:^{
//        [self.view layoutIfNeeded];
//    }];
    
    [UIView animateWithDuration:2 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)UIImagePickerController{
    // 创建一个RACDelegateProxy
    RACDelegateProxy *imgPickerDelegateProxy = [[RACDelegateProxy alloc] initWithProtocol:@protocol(UIImagePickerControllerDelegate)];
    
    // 绑定取消代理事件
    [[imgPickerDelegateProxy
      rac_signalForSelector:@selector(imagePickerControllerDidCancel:)]
     subscribeNext:^(RACTuple * _Nullable x) {
         NSLog(@"取消代理: %@", x);
         UIImagePickerController *imgPicker = x[0];
         [imgPicker dismissViewControllerAnimated:YES completion:nil];
     }];
    
    // 绑定选择完毕事件
    [[imgPickerDelegateProxy
      rac_signalForSelector:@selector(imagePickerController:didFinishPickingImage:editingInfo:)]
     subscribeNext:^(RACTuple * _Nullable x) {
         
         NSLog(@"选择完成: %@", x);
         self.view.backgroundColor = [UIColor colorWithPatternImage:x[1]];
         
         UIImagePickerController *imgPicker = x[0];
         [imgPicker dismissViewControllerAnimated:YES completion:nil];
     }];
    
    // 创建UIImagePickerController
    UIImagePickerController *imgPickerController = [[UIImagePickerController alloc] init];
    imgPickerController.sourceType    = UIImagePickerControllerSourceTypePhotoLibrary;
    imgPickerController.allowsEditing = YES;
    
    // 设置代理为我们创建的delegateProxy
    // 这里注意一般UIImagePickerController需要实现UIImagePickerDelegate & UINavigationControllerDelegate, 但这里用RAC自带的方法只能设置一个代理
    // 不过其实RAC其实也只为UIImagePickerController处理了UIImagePickerControllerDelegate而已, 所以这里会有警告先不管它
    // 后面我们再想想其他方式,  是重新写一个UIImagePickerController分类还是重写方法什么的
    
    imgPickerController.delegate      = (id<UIImagePickerControllerDelegate>)imgPickerDelegateProxy;
    
    [self presentViewController:imgPickerController animated:YES completion:nil];
}

- (void)dataPickerAndTextF{
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 160)];
    datePicker.center = self.view.center;
    datePicker.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:datePicker];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 180, 35)];
    textField.center = CGPointMake(self.view.center.x, self.view.center.y - 100);
    textField.backgroundColor = [UIColor yellowColor];
    
    [self.view addSubview:textField];
    RACChannelTerminal *datePickerTerminal = [datePicker rac_newDateChannelWithNilValue:[NSDate date]];
    RACChannelTerminal *textFieldTerminal  = [textField rac_newTextChannel];
    
    [[datePickerTerminal
      map:^id _Nullable(id  _Nullable value) {
          
          NSLog(@"%@", value);
          NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
          [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
          return [dateFormatter stringFromDate:value];
      }]
     subscribe:textFieldTerminal];
}


- (runBlcok)runBlock {
    runBlcok block = ^() {
        // 延时2s
        [NSThread sleepForTimeInterval:2];
        return self;
    };
    
    return block;
}
- (MRViewController * (^)())walkBlock {
    MRViewController * (^block)() = ^() {
        NSLog(@"walk");
        // 延时2s
        [NSThread sleepForTimeInterval:2];
        return self;
    };
    return block;
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
