//
//  DataAccessViewController.m
//  AFKitDemo
//
//  Created by zws on 2017/12/11.
//  Copyright © 2017年 AF. All rights reserved.
//

#import "DataAccessViewController.h"
#import "Student.h"
#import "UIButton+runtime.h"
#import <CoreData/CoreData.h>
#define KUserDefaults [NSUserDefaults standardUserDefaults]

@interface DataAccessViewController ()

@end

@implementation DataAccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray *buttons = @[@{@"name":@"plist文件",@"selector":@"DataAccessWithPlist"},
                         @{@"name":@"NSUserdefaults",@"selector":@"DataAccessWithUserDefault"},
                         @{@"name":@"NSKeyedArchiver",@"selector":@"DataAccessWithNSKeyedArchiver"},
                         @{@"name":@"CoreData",@"selector":@"DataAccessWithCoreData"}
                         ];
    NSInteger col = 3;//
    CGFloat margin = 20;
    CGFloat viewW = (ScreenWidth - (col - 1) * margin) / col;
    CGFloat viewH = viewW;
    for (int i = 0; i < buttons.count; i ++) {
        NSInteger index = i;//
        CGFloat viewX = (index % col ) * (viewW + margin);
        NSLog(@"----%ld",(index % col ));
        CGFloat viewY = (index / col ) * (viewH + 10);
        __weak typeof(self)weakSelf = self;
        UIButton *button = [UIButton ButtonWithFrame:CGRectMake(viewX, viewY, viewW, viewH) title:buttons[i][@"name"] actionBlock:^(UIButton *button) {
            SEL se = NSSelectorFromString(buttons[i][@"selector"]);
            [weakSelf performSelector:se];
        }];
        [button setBackgroundColor:RandomColor];
        [self.view addSubview:button];
    }
}

/**
属性列表
属性列表是一种XML格式的文件，拓展名为plist
如果对象是NSString、NSDictionary、NSArray、NSData、NSNumber等类型，就可以使用writeToFile:atomically:方法直接将对象写到属性列表文件中
 */
- (void)DataAccessWithPlist{
    //将一个NSDictionary对象归档到一个plist属性列表中
    //将数据封装成字典
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"小明" forKey:@"name"];
    [dict setObject:@"15013141314" forKey:@"phone"];
    [dict setObject:@"27" forKey:@"age"];
    //获取Documents沙盒路径
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingString:@"/student.plist"];
    NSLog(@"存储地址--path:%@",path);
    [dict writeToFile:path atomically:YES];
    
    //取出
    NSDictionary *outDic = [NSDictionary dictionaryWithContentsOfFile:path];
    NSLog(@"取出对象--outDic:%@",outDic);
}

/*
 偏好设置
 nsuserdefaults 可储存类型
 NSData
 NSString
 NSNumber
 NSDate
 NSArray
 NSDictionary
 */
- (void)DataAccessWithUserDefault{
    [KUserDefaults setObject:@"小明" forKey:@"name"];
    [KUserDefaults setBool:YES forKey:@"loveMe"];
    //强制写入
    [KUserDefaults synchronize];
    //取出
    NSLog(@"取出--%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"name"]);
    

    //自定义对象
    Student *s = [[Student alloc] init];
    s.name = @"小红";
    s.age = 12;
    [KUserDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:s] forKey:@"student"];
    //取出
    NSLog(@"取出--%@",[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] valueForKey:@"student"]]);
}

- (void)DataAccessWithNSKeyedArchiver{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingString:@"/NSKeyedArchiver"];
    [NSKeyedArchiver archiveRootObject:@[@"1",@"2"] toFile:path];
    NSLog(@"取出--%@",[NSKeyedUnarchiver unarchiveObjectWithFile:path]);
}


- (void)DataAccessWithCoreData{
    //从应用程序包中加载模型文件
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    //传入模型，初始化NSPersistentStoreCoordinator
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    //构建SQLite文件路径
    NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSURL *url = [NSURL fileURLWithPath:[docs stringByAppendingPathComponent:@"person.data"]];
    //搭建Core Data上下文环境
    //添加持久化存储库，这里使用SQLite作为存储库
    NSError *error = nil;
    NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
    if (store == nil) { //直接抛异常
        [NSException raise:@"添加数据库错误" format:@"%@", [error localizedDescription]];
    }
    //初始化上下文，设置persistentStoreCoordinator属性
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    context.persistentStoreCoordinator = psc;
    //添加数据
   // 传入上下文，创建一个Person实体对象
    NSManagedObject *person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:context];
    //设置简单属性
    [person setValue:@"MJ" forKey:@"name"];
    [person setValue:[NSNumber numberWithInt:27] forKey:@"age"];
    //传入上下文，创建一个Card实体对象
    NSManagedObject *card = [NSEntityDescription insertNewObjectForEntityForName:@"Card" inManagedObjectContext:context];
    [card setValue:@"4414241933432" forKey:@"no"];
    //设置Person和Card之间的关联关系
    [person setValue:card forKey:@"card"];
    //利用上下文对象，将数据同步到持久化存储库
    NSError *errort = nil;
    BOOL success = [context save:&errort];
    if (!success) {
        [NSException raise:@"访问数据库错误" format:@"%@", [error localizedDescription]];
    }
    //如果是想做更新操作：只要在更改了实体对象的属性后调用[context save:&error]，就能将更改的数据同步到数据库
    
    
    //查询数据
    //初始化一个查询请求
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    //设置要查询的实体
    NSEntityDescription *desc = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:context];
    //设置排序（按照age降序）
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"age" ascending:NO];
    request.sortDescriptors = [NSArray arrayWithObject:sort];
    //设置条件过滤(name like '%Itcast-1%')
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name like %@", @"*Itcast-1*"];
//    request.predicate = predicate;
    request.entity = desc;
    //执行请求
    NSError *errors = nil;
    NSArray *objs = [context executeFetchRequest:request error:&errors];
    if (errors) {
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
    }
    //遍历数据
    for (NSManagedObject *obj in objs) {
        NSLog(@"name=%@", [obj valueForKey:@"name"]);
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
