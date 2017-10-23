//
//  HomeViewController.m
//  AFTempProject
//
//  Created by ZWS on 17/9/6.
//  Copyright © 2017年 AF. All rights reserved.
//

#import "HomeViewController.h"
#import "GridViewController.h"

@interface HomeViewController ()

@property (nonatomic,strong)NSMutableArray *dataSource;

@end

@implementation HomeViewController

- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        [self setEdgesForExtendedLayout: UIRectEdgeNone];
    }
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self loadData];
}

- (void)loadData{
    NSArray *tempArr = @[
                         @{CELLTITLE:@"九宫格算法",CELLVCNAME:@"GridViewController"},
                         @{CELLTITLE:@"控制器转场动画",CELLVCNAME:@"GridViewController"},];
    [self.dataSource addObjectsFromArray:tempArr];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark | UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)idp {
    [tableView deselectRowAtIndexPath:idp animated:YES];
    Class vcClass = NSClassFromString(self.dataSource[idp.row][CELLVCNAME]);
    [self.navigationController pushViewController:[[vcClass alloc] init] animated:YES];
}

#pragma mark | UITableViewdsNearbyPeople

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)idp {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:idp];
    //右侧箭头
    cell.accessoryType    = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text   = self.dataSource[idp.row][CELLTITLE];
    return cell;
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
