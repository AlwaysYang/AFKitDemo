//
//  MRViewController.h
//  AFKitDemo
//
//  Created by zws on 2017/12/13.
//  Copyright © 2017年 AF. All rights reserved.
//

#import "HYBHelperKitBaseController.h"

@class MRViewController;

typedef MRViewController * (^runBlcok)();

@interface MRViewController : HYBHelperKitBaseController


/** runblock*/
@property (nonatomic,strong)runBlcok runBlock;

@end
