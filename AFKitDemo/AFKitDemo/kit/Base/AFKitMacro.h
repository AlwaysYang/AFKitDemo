//
//  AFKitMacro.h
//  AFKitDemo
//
//  Created by 猪卫士 on 16/11/9.
//  Copyright © 2016年 AF. All rights reserved.
//

#ifndef AFKitMacro_h
#define AFKitMacro_h
#import "Masonry.h"

/**
 Synthsize a dynamic object property in @implementation scope.
 It allows us to add custom properties to existing classes in categories.
 
 @param association  ASSIGN / RETAIN / COPY / RETAIN_NONATOMIC / COPY_NONATOMIC
 @warning #import <objc/runtime.h>
 *******************************************************************************
 Example:
 @interface NSObject (MyAdd)
 @property (nonatomic, retain) UIColor *myColor;
 @end
 
 #import <objc/runtime.h>
 @implementation NSObject (MyAdd)
 YYSYNTH_DYNAMIC_PROPERTY_OBJECT(myColor, setMyColor, RETAIN, UIColor *)
 @end
 */
//使用runtime 运行时属性 给catetory 动态添加属性
#ifndef YYSYNTH_DYNAMIC_PROPERTY_OBJECT
#define YYSYNTH_DYNAMIC_PROPERTY_OBJECT(_getter_, _setter_, _association_, _type_) \
- (void)_setter_ : (_type_)object { \
[self willChangeValueForKey:@#_getter_]; \
objc_setAssociatedObject(self, _cmd, object, OBJC_ASSOCIATION_ ## _association_); \
[self didChangeValueForKey:@#_getter_]; \
} \
- (_type_)_getter_ { \
return objc_getAssociatedObject(self, @selector(_setter_:)); \
}
#endif

#pragma mark - 强弱引用

/**
 Synthsize a weak or strong reference.
 
 Example:
 @weakify(self)
 [self doSomething^{
 @strongify(self)
 if (!self) return;
 ...
 }];
 
 */
#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

#pragma mark - 手机型号 系统版本

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define iOS(version) ([[UIDevice currentDevice].systemVersion floatValue] >= version)

// Fast to get iOS system version
#define kIOSVersion ([UIDevice currentDevice].systemVersion.floatValue)

#pragma mark - 重写NSLog

//重写NSLog,Debug模式下打印日志和当前行数
#if DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"\nfunction:%s line:%d content:%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif

#pragma mark - 屏幕宽高

//屏幕宽度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
//屏幕高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#pragma mark - GCD线程
//GCD - 一次性执行
#define AFDISPATCH_ONCE_BLOCK(onceBlock) static dispatch_once_t onceToken; dispatch_once(&onceToken, onceBlock);

//GCD - 在Main线程上运行
#define AFDISPATCH_MAIN_THREAD(mainQueueBlock) dispatch_async(dispatch_get_main_queue(), mainQueueBlock);

//GCD - 开启异步线程
#define AFDISPATCH_GLOBAL_QUEUE_DEFAULT(globalQueueBlock) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), globalQueueBlock);


#pragma mark - 颜色

#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
//传入RGB三个参数，得到颜色
#define RGB(r,g,b) RGBA(r,g,b,1.f)
//取得随机颜色
#define RandomColor RGB(arc4random()%256,arc4random()%256,arc4random()%256)

#define GrayColor      [UIColor grayColor]
#define BlackColor     [UIColor blackColor]
#define WhiteColor     [UIColor whiteColor]
#define RedColor       [UIColor redColor]
#define BlueColor      [UIColor blueColor]
#define OrangeColor    [UIColor orangeColor]
#define LightGrayColor [UIColor lightGrayColor]
#define LightTextColor [UIColor lightTextColor]
#define ClearColor [UIColor clearColor]


#pragma mark - Font Font
// Generate font with size
#define AFFontWithSize(size) [UIFont systemFontOfSize:size]

// Generate bold font with size.
#define AFBoldFontWithSize(size) [UIFont boldSystemFontOfSize:size]


#pragma mark - 本地图片的加载
// More easy way to load an image.
#define AFImageWithName(Name) ([UIImage imageNamed:Name])

// More easy to load an image from file.
#define AFImageOfFile(Name) ([UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:Name ofType:nil]])

#pragma mark - 系统单例

// More easy way to get user default object.
#define AFUserDefaults [NSUserDefaults standardUserDefaults]

// More easy way to get NSNotificationCenter object.
#define AFNotificationCenter  [NSNotificationCenter defaultCenter]

// More easy way to get [NSFileManager defaultManager]
#define AFFileManager [NSFileManager defaultManager]

// More easy way to post a notification from notification center.
#define AFPostNotificationWithName(notificationName) \
[kNotificationCenter postNotificationName:notificationName object:nil userInfo:nil]

// More easy way to post a notification with user info from notification center.
#define kPostNotificationWithNameAndUserInfo(notificationName, userInfo) \
[kNotificationCenter postNotificationName:notificationName object:nil userInfo:userInfo]

#pragma mark - 弹出框
/*! 警告框-一个按钮【VC】 */
#define AF_SHOW_ALERT(title, msg)  UIAlertController *afAlert = [UIAlertController alertControllerWithTitle:title  message:msg preferredStyle:UIAlertControllerStyleAlert];\
[afAlert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {\
}]];\
[self presentViewController:afAlert animated:YES completion:nil];\

#pragma mark - 验证

// Judge whether it is an empty string.
#define AFIsEmptyString(s) (s == nil || [s isKindOfClass:[NSNull class]] || ([s isKindOfClass:[NSString class]] && s.length == 0))


// Judge whether it is a nil or null object.
#define AFIsEmptyObject(obj) (obj == nil || [obj isKindOfClass:[NSNull class]])

// Judge whether it is a vaid dictionary.
#define AFIsDictionary(objDict) (objDict != nil && [objDict isKindOfClass:[NSDictionary class]])

// Judge whether it is a valid array.
#define AFIsArray(objArray) (objArray != nil && [objArray isKindOfClass:[NSArray class]])

// Judge whether the device it is ipad.
#define AFIsIPad \
([[UIDevice currentDevice] respondsToSelector:@selector(userInterfaceIdiom)]\
&& [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

// Judge whether current orientation is landscape.
#define AFIsLandscape (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))

#pragma mark - Blocks
/**
 *	This is a common block for handling error.
 */
typedef void (^HYBErrorBlock)(NSError *error);

/**
 * This is a void block.
 */
typedef void (^HYBVoidBlock)(void);

/**
 *	This is a common block for handling to return a string value.
 */
typedef void (^HYBStringBlock)(NSString *result);

/**
 * For notification block.
 */
typedef void (^HYBNotificationBlock)(NSNotification *sender);

/**
 *	For return a bool block.
 */
typedef void (^HYBBOOLBlock)(BOOL result);

/**
 * For return a array block.
 */
typedef void (^HYBArrayBlock)(NSArray *list);

/**
 * For return a array and msg block.
 */
typedef void (^HYBArrayMessageBlock)(NSArray *list, NSString *msg);

/**
 * For return a dictionary block.
 */
typedef void (^HYBDictionaryBlock)(NSDictionary *response);

/**
 * For return a dictionary and a message block.
 */
typedef void (^HYBDictionaryMessageBlock)(NSDictionary *response, NSString *msg);

/**
 * For only return number block.
 */
typedef void (^HYBNumberBlock)(NSNumber *resultNumber);

/**
 * For number and message block.
 */
typedef void (^HYBNumberMessageBlock)(NSNumber *resultNumber, NSString *msg);

/**
 * Common return object block.
 */
typedef void (^HYBIdBlock)(id result);

/**
 * For single button block.
 */
typedef void(^HYBButtonBlock)(UIButton *sender);

/**
 *	@author https://github.com/CoderJackyHuang
 *
 *	Common value change block.
 *
 *	@param sender	The responder
 */
typedef void(^HYBValueChangedBlock)(id sender);

/**
 *	@author https://github.com/CoderJackyHuang
 *
 *	Common edit change block, eg: UITextField.
 *
 *	@param sender	The responder.
 */
typedef void(^HYBEditChangedBlock)(id sender);

/**
 * For button array block.
 *
 * @param index  index in the array.
 * @param sender The responder.
 */
typedef void(^HYBButtonIndexBlock)(NSUInteger index, UIButton *sender);

/**
 * Gesture block callback.
 */
typedef void(^HYBGestureBlock)(UIGestureRecognizer *sender);

/**
 *	@author https://github.com/CoderJackyHuang
 *
 *	The long press gesture callback block.
 *
 *	@param sender	The long press gesture.
 */
typedef void(^HYBLongGestureBlock)(UILongPressGestureRecognizer *sender);

/**
 *	@author https://github.com/CoderJackyHuang
 *
 *	The tap gesture callback block.
 *
 *	@param sender	The tap gesture.
 */
typedef void(^HYBTapGestureBlock)(UITapGestureRecognizer *sender);

/**
 *	@author https://github.com/CoderJackyHuang
 *
 *	Masonry Kit Need To Use It.
 */
typedef void(^HYBConstraintMaker)(MASConstraintMaker *make);




#endif /* AFKitMacro_h */
