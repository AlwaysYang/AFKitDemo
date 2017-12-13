//
//  UIButton+runtime.m
//  AFKitDemo
//
//  Created by zws on 2017/12/11.
//  Copyright © 2017年 AF. All rights reserved.
//

#import "UIButton+runtime.h"
#import <objc/runtime.h>

//static
static NSString *keyOfMethod = @"keyOfMethod";
static NSString *keyOfBlock = @"keyOfBlock";

@implementation UIButton (runtime)

+ (UIButton *)ButtonWithFrame:(CGRect)frame title:(NSString *)title actionBlock:(ActionBlock)actionBlock{
    UIButton *button = [[UIButton alloc]init];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:button action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    /*
     objc_setAssociatedObject(id object, const void *key, id value, objc_AssociationPolicy policy)
     id object                     :表示关联者，是一个对象，变量名理所当然也是object
     const void *key               :获取被关联者的索引key
     id value                      :被关联者，这里是一个block
     objc_AssociationPolicy policy : 关联时采用的协议，有assign，retain，copy等协议，一般使用OBJC_ASSOCIATION_RETAIN_NONATOMIC
     */
    objc_setAssociatedObject(button, (__bridge const void * _Nonnull)(keyOfMethod), actionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    return button;
}

- (void)buttonClick:(UIButton *)button{
    //通过key获取被关联对象 （此处为一个block）
    ActionBlock actionBlock = objc_getAssociatedObject(button, CFBridgingRetain(keyOfMethod));
    if (actionBlock) {
        actionBlock(button);
    }
}

- (void)setActionBlock:(ActionBlock)actionBlock{
    objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(keyOfMethod), actionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (ActionBlock)actionBlock{

    return objc_getAssociatedObject(self, CFBridgingRetain(keyOfMethod));
}

@end
