//
//  UINavigationItem+AFCustomBackButton.m
//  PullWires
//
//  Created by ZWS on 17/6/26.
//  Copyright © 2017年 AF. All rights reserved.
//

#import "UINavigationItem+AFCustomBackButton.h"
#import <objc/runtime.h>
static char kCustomBackButtonKey;

@implementation UINavigationItem (AFCustomBackButton)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originalMethodImp = class_getInstanceMethod(self, @selector(backBarButtonItem));
        Method destMethodImp = class_getInstanceMethod(self, @selector(myCustomBackButton_backBarbuttonItem));
        method_exchangeImplementations(originalMethodImp, destMethodImp);
    });
}

- (UIBarButtonItem *)myCustomBackButton_backBarbuttonItem {
    UIBarButtonItem *item = [self myCustomBackButton_backBarbuttonItem];
    if (item) {
        return item;
    }
    
    item = objc_getAssociatedObject(self, &kCustomBackButtonKey);
    if (!item) {
        item = [[UIBarButtonItem alloc] initWithTitle:@"🔙" style:UIBarButtonItemStylePlain target:nil action:nil];
        item.tintColor = [UIColor blackColor];
    }
    return item;
}


@end
