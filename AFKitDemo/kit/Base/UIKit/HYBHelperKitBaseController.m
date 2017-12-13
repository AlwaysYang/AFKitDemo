//
//  HYBHelperKitBaseController.m
//  HYBHelperKit
//
//  Created by huangyibiao on 16/7/5.
//  Copyright © 2016年 huangyibiao. All rights reserved.
//

#import "HYBHelperKitBaseController.h"
#import <objc/runtime.h>
#import "NSArray+AFAdd.h"
#import "UIButton+HYBHelperBlockKit.h"
@interface HYBHelperKitBaseController ()

@property (nonatomic, strong) NSMutableArray *hyb_notificationNames;
@property (nonatomic, strong) UIActivityIndicatorView *hyb_loadingView;

@end

@implementation HYBHelperKitBaseController

- (void)dealloc {
  [self hyb_removeAllNotifications];
  
#if DEBUG
  NSLog(@"%@ dealloc", [[self class] description]);
#endif
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.edgesForExtendedLayout = UIRectEdgeNone;
  self.automaticallyAdjustsScrollViewInsets = NO;
  self.view.backgroundColor = WhiteColor;
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
#if DEBUG
  NSLog(@"%@ viewDidAppear", [[self class] description]);
#endif
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  
#if DEBUG
  NSLog(@"%@ viewDidDisappear", [[self class] description]);
#endif
}

- (UIButton *)hyb_leftButtonItem {
  return [[self hyb_leftButtonItems] objectOrNilAtIndex:0];
}

- (NSArray<UIButton *> *)hyb_leftButtonItems {
  NSMutableArray *array = [[NSMutableArray alloc] init];
  
  NSArray *leftItems = self.navigationItem.leftBarButtonItems;
  for (UIBarButtonItem *item in leftItems) {
    if ([item isKindOfClass:[UIBarButtonItem class]]) {
      if ([item.customView isKindOfClass:[UIButton class]]) {
        [array addObject:item.customView];
      }
    }
  }
  
  return array;
}

- (UIButton *)hyb_rightButtonItem {
  return [[self hyb_rightButtonItems] objectOrNilAtIndex:0];
}

- (NSArray<UIButton *> *)hyb_rightButtonItems {
  NSMutableArray *array = [[NSMutableArray alloc] init];
  
  NSArray *rightItems = self.navigationItem.rightBarButtonItems;
  for (UIBarButtonItem *item in rightItems) {
    if ([item isKindOfClass:[UIBarButtonItem class]]) {
      if ([item.customView isKindOfClass:[UIButton class]]) {
        [array addObject:item.customView];
      }
    }
  }
  
  return array;
}

- (void)hyb_adjustNavigationTitleToCenter {
  NSArray *viewControllerArray = [self.navigationController viewControllers];
  
  long previousViewControllerIndex = [viewControllerArray indexOfObject:self] - 1;
  UIViewController *previous;
  
  if (previousViewControllerIndex >= 0) {
    previous = [viewControllerArray objectAtIndex:previousViewControllerIndex];
    previous.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                                 initWithTitle:@" "
                                                 style:UIBarButtonItemStylePlain
                                                 target:self
                                                 action:nil];
  }
}

- (void)hyb_setNavTitle:(id)title
             rightTitle:(NSString *)rightTitle
             rightBlock:(HYBButtonBlock)rightBlock {
  if (AFIsEmptyString(rightTitle)) {
    return [self hyb_setNavTitle:title];
  }
  
  return [self hyb_setNavTitle:title rightTitles:@[rightTitle] rightBlock:^(NSUInteger index, UIButton *sender) {
    if (rightBlock) {
      rightBlock(sender);
    }
  }];
}

- (void)hyb_setNavTitle:(id)title
            rightTitles:(NSArray<NSString *> *)rightTitles
             rightBlock:(HYBButtonIndexBlock)rightBlock {
  [self hyb_setNavTitle:title];
  
  if (AFIsArray(rightTitles) && rightTitles.count >= 1) {
    NSUInteger i = 0;
    NSMutableArray *rightButtons = [[NSMutableArray alloc] init];
    for (NSString *title in rightTitles) {
      UIButton *btn = [UIButton hyb_buttonWithTitle:title superView:nil constraints:nil touchUp:^(UIButton *sender) {
        if (rightBlock) {
          rightBlock(i, sender);
        }
      }];
      
      [rightButtons addObject:btn];
      i++;
    }
    
    [self _hyb_setNavItems:rightButtons isLeft:NO];
  }
}

- (void)hyb_setNavTitle:(id)title
            rightImages:(NSArray *)rightImages
             rightBlock:(HYBButtonIndexBlock)rightBlock {
  return [self hyb_setNavTitle:title
                   rightImages:rightImages
                 rightHgImages:nil
                    rightBlock:rightBlock];
}

- (void)hyb_setNavTitle:(id)title
            rightImages:(NSArray *)rightImages
          rightHgImages:(NSArray *)rightHgImages
             rightBlock:(HYBButtonIndexBlock)rightBlock {
  [self hyb_setNavTitle:title];
  
  if (AFIsArray(rightImages) && rightHgImages.count >= 1) {
    NSUInteger i = 0;
    NSMutableArray *rightButtons = [[NSMutableArray alloc] init];
    for (NSString *imgName in rightImages) {
      NSString *last = [rightHgImages objectOrNilAtIndex:i];
      
      UIButton *btn = [UIButton hyb_buttonWithImage:imgName superView:nil constraints:nil touchUp:^(UIButton *sender) {
        if (rightBlock) {
          rightBlock(i, sender);
        }
      }];
      
      UIImage *hgImage = nil;
      if ([last isKindOfClass:[UIImage class]]) {
        hgImage = (UIImage *)last;
      } else if ([last isKindOfClass:[NSString class]]) {
        hgImage = AFImageWithName(last);
      }
      
      if (hgImage) {
        [btn setImage:hgImage forState:UIControlStateHighlighted];
      }
      
      [rightButtons addObject:btn];
      i++;
    }
    
    [self _hyb_setNavItems:rightButtons isLeft:NO];
  }
}

- (void)hyb_setNavLeftButtonTitle:(NSString *)title onCliked:(HYBButtonBlock)block {
  UIButton *btn = [UIButton hyb_buttonWithTitle:title
                                      superView:nil
                                    constraints:nil
                                        touchUp:block];
  
  [self _hyb_setNavItems:@[btn] isLeft:YES];
}

- (void)hyb_setNavLeftImage:(id)image block:(HYBButtonBlock)block {
  UIImage *normalImage = image;
  
  if ([normalImage isKindOfClass:[NSString class]]) {
    normalImage = AFImageWithName(image);
  }
  
  UIButton *btn = [UIButton hyb_buttonWithImage:image
                                      superView:nil
                                    constraints:nil
                                        touchUp:block];
  
  [self _hyb_setNavItems:@[btn] isLeft:YES];
}

- (void)hyb_setNavTitle:(id)title {
  if ([title isKindOfClass:[NSString class]]) {
    self.navigationItem.title = title;
  } else if ([title isKindOfClass:[UIView class]]) {
    self.navigationItem.titleView = title;
  } else if ([title isKindOfClass:[UIImage class]]) {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:(UIImage *)title];
    self.navigationItem.titleView = imageView;
    [imageView sizeToFit];
  }
}

#pragma mark - Notification
- (void)hyb_addObserverWithNotificationName:(NSString *)notificationName
                                   callback:(HYBNotificationBlock)callback {
  if (AFIsEmptyString(notificationName)) {
    return;
  }
  
  [self hyb_addNotificationName:notificationName];
    
  
  [AFNotificationCenter addObserver:self
                          selector:@selector(hyb_onRecievedNotification:)
                              name:notificationName
                            object:nil];
  objc_setAssociatedObject(self,
                           (__bridge const void *)(notificationName),
                           callback,
                           OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)hyb_removeAllNotifications {
  // 移除监听
  for (NSString *name in self.hyb_notificationNames) {
    [AFNotificationCenter removeObserver:self name:name object:nil];
    // 取消关联
    objc_setAssociatedObject(self,
                             (__bridge const void *)(name),
                             nil,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
  }
  
  [AFNotificationCenter removeObserver:self];
}

- (void)hyb_removeAllNotificationWithName:(NSString *)nofiticationName {
  if (AFIsEmptyString(nofiticationName)) {
    return;
  }
  
  // 移除监听
  for (NSString *name in self.hyb_notificationNames) {
    if ([name isEqualToString:nofiticationName]) {
      [AFNotificationCenter removeObserver:self name:name object:nil];
      // 取消关联
      objc_setAssociatedObject(self,
                               (__bridge const void *)(name),
                               nil,
                               OBJC_ASSOCIATION_COPY_NONATOMIC);
      break;
    }
  }
}

- (UIActivityIndicatorView *)hyb_startIndicatorAnimating {
  return [self hyb_startIndicatorAnimatingWithStyle:UIActivityIndicatorViewStyleGray];
}

- (UIActivityIndicatorView *)hyb_startIndicatorAnimatingWithStyle:(UIActivityIndicatorViewStyle)style {
  if (self.hyb_loadingView == nil) {
    self.hyb_loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
    [self.view addSubview:self.hyb_loadingView];
    
    @weakify(self)
    if (self.navigationController && self.navigationController.navigationBarHidden == NO) {
        @strongify(self)
      [self.hyb_loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-64 / 2);
      }];
    } else {
      [self.hyb_loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
      }];
    }
  }
  
  [self.view bringSubviewToFront:self.hyb_loadingView];
  [self.hyb_loadingView startAnimating];
  
  return self.hyb_loadingView;
}

- (void)hyb_stopIndicatorAnimating {
  [self.hyb_loadingView stopAnimating];
  
  [self.hyb_loadingView removeFromSuperview];
  self.hyb_loadingView = nil;
}

#pragma mark - Private
- (void)_hyb_setNavItems:(NSArray *)buttons isLeft:(BOOL)isLeft {
  UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                     target:nil
                                     action:nil];
  negativeSpacer.width = -8;
  if (kIOSVersion < 7) {
    negativeSpacer.width = 0;
  }
  
  NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:buttons.count];
  [items addObject:negativeSpacer];
  
  for (NSUInteger i = 0; i < buttons.count; ++i) {
    UIButton *btn = [buttons objectOrNilAtIndex:i];
    [btn sizeToFit];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [items addObject:item];
  }
  
  if (isLeft) {
    self.navigationItem.leftBarButtonItems = items;
  } else {
    self.navigationItem.rightBarButtonItems = items;
  }
}

- (void)hyb_addNotificationName:(NSString *)name {
  for (NSString *notificationName in self.hyb_notificationNames) {
    if ([notificationName isEqualToString:name]) {
      return;
    }
  }
  
  [self.hyb_notificationNames addObject:name];
}

- (void)hyb_onRecievedNotification:(NSNotification *)notification {
  for (NSString *name in self.hyb_notificationNames) {
    if ([name isEqualToString:notification.name]) {
      HYBNotificationBlock block = objc_getAssociatedObject(self,
                                                            (__bridge const void *)(notification.name));
      if (block) {
        block(notification);
      }
      
      break;
    }
  }
}

- (NSMutableArray *)hyb_notificationNames {
  if (_hyb_notificationNames == nil) {
    _hyb_notificationNames = [[NSMutableArray alloc] init];
  }
  
  return _hyb_notificationNames;
}

@end
