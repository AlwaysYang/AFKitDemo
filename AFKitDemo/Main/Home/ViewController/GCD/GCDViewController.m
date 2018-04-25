//
//  GCDViewController.m
//  AFKitDemo
//
//  Created by zws on 2017/12/18.
//  Copyright © 2017年 AF. All rights reserved.
//

#import "GCDViewController.h"

@interface GCDViewController ()

@end

@implementation GCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //可以使用dispatch_queue_create来创建对象，需要传入两个参数，第一个参数表示队列的唯一标识符，用于DEBUG，可为空；第二个参数用来识别是串行队列还是并行队列。DISPATCH_QUEUE_SERIAL表示串行队列，DISPATCH_QUEUE_CONCURRENT表示并行队列。
    
    //创建一个串行队列
    dispatch_queue_t que = dispatch_queue_create("que", DISPATCH_QUEUE_SERIAL);
    //创建一个并行队列
    dispatch_queue_t queB = dispatch_queue_create("queB", DISPATCH_QUEUE_CONCURRENT);
//    对于并行队列，还可以使用dispatch_get_global_queue来创建全局并行队列。GCD默认提供了全局的并行队列，需要传入两个参数。第一个参数表示队列优先级，一般用DISPATCH_QUEUE_PRIORITY_DEFAULT。第二个参数暂时没用，用0即可。
    dispatch_queue_t queB2 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    
    //并行功能只有在 异步执行下才有效
 
    
//    //1. 同步执行 并行队列
//    [self syncConcurrent];
//
//    //2. 异步执行 并行队列
//    [self asyncConcurrent];
//
//    //3. 同步执行 串行队列
//    [self syncSerial];
//
//    //4 异步执行 串行队列
//    [self asyncConcurrent];
//
//    //同步  主队列
//    [self syncMain];
    
    [self dispatch_group];
}

- (void)syncConcurrent{
    NSLog(@"syncConcurrent---begin");
    dispatch_queue_t queue= dispatch_queue_create("test.queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"1------%@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"2------%@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"3------%@",[NSThread currentThread]);
        }
    });
    
    NSLog(@"syncConcurrent---end");
//    从并行队列 + 同步执行中可以看到，所有任务都是在主线程中执行的。由于只有一个线程，所以任务只能一个一个执行
//    同时我们还可以看到，所有任务都在打印的syncConcurrent---begin和syncConcurrent---end之间，这说明任务是添加到队列中马上执行的。
}

- (void)asyncConcurrent
{
    NSLog(@"asyncConcurrent---begin");
    
    dispatch_queue_t queue= dispatch_queue_create("test.queue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"1------%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"2------%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"3------%@",[NSThread currentThread]);
        }
    });
    
    NSLog(@"asyncConcurrent---end");
//    在并行队列 + 异步执行中可以看出，除了主线程，又开启了3个线程，并且任务是交替着同时执行的。
//    另一方面可以看出，所有任务是在打印的syncConcurrent---begin和syncConcurrent---end之后才开始执行的。说明任务不是马上执行，而是将所有任务添加到队列之后才开始异步执行。
}
- (void)syncSerial
{
    NSLog(@"syncSerial---begin");
    
    dispatch_queue_t queue = dispatch_queue_create("test.queue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"1------%@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"2------%@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"3------%@",[NSThread currentThread]);
        }
    });
    
    NSLog(@"syncSerial---end");
//    在串行队列 + 同步执行可以看到，所有任务都是在主线程中执行的，并没有开启新的线程。而且由于串行队列，所以按顺序一个一个执行。
//    同时我们还可以看到，所有任务都在打印的syncConcurrent---begin和syncConcurrent---end之间，这说明任务是添加到队列中马上执行的。
    
}

- (void) asyncSerial
{
    NSLog(@"asyncSerial---begin");
    
    dispatch_queue_t queue = dispatch_queue_create("test.queue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"1------%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"2------%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"3------%@",[NSThread currentThread]);
        }
    });
    
    NSLog(@"asyncSerial---end");
//    在串行队列 + 异步执行可以看到，开启了一条新线程，但是任务还是串行，所以任务是一个一个执行。
//    另一方面可以看出，所有任务是在打印的syncConcurrent---begin和syncConcurrent---end之后才开始执行的。说明任务不是马上执行，而是将所有任务添加到队列之后才开始同步执行。
}


- (void)syncMain
{
    NSLog(@"syncMain---begin");
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"1------%@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"2------%@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"3------%@",[NSThread currentThread]);
        }
    });
    
    NSLog(@"syncMain---end");
//    这时候，我们惊奇的发现，在主线程中使用主队列 + 同步执行，任务不再执行了，而且syncMain---end也没有打印。这是为什么呢？
//
//    这是因为我们在主线程中执行这段代码。我们把任务放到了主队列中，也就是放到了主线程的队列中。而同步执行有个特点，就是对于任务是立马执行的。那么当我们把第一个任务放进主队列中，它就会立马执行。但是主线程现在正在处理syncMain方法，所以任务需要等syncMain执行完才能执行。而syncMain执行到第一个任务的时候，又要等第一个任务执行完才能往下执行第二个和第三个任务。
//
//    那么，现在的情况就是syncMain方法和第一个任务都在等对方执行完毕。这样大家互相等待，所以就卡住了，所以我们的任务执行不了，而且syncMain---end也没有打印。
    
//    要是如果不再主线程中调用，而在其他线程中调用会如何呢？
//
//    不会开启新线程，执行完一个任务，再执行下一个任务（在其他线程中调用）
    
}


- (void)dispatch_group{
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       //1耗时的异步操作
        sleep(2);
        NSLog(@"第一个任务");
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //1耗时的异步操作
        sleep(2);
        NSLog(@"第2个任务");
    });
    //操作完回到主线程 共用时 2s
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"两个任务已完成 ");
    });
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
