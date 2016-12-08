//
//  DJMineController.m
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/18.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import "DJMineController.h"
#import "DJMineCell.h"
#import "DJHeaderCell.h"
#import "AppDelegate.h"
#import "DDMenuController.h"
#import "MyTabBarViewController.h"
#import "DJNewsViewController.h"
#import "DJFavoriteController.h"
#import "DJSuggestController.h"


@interface DJMineController ()<UITableViewDelegate,UITableViewDataSource>
{
    CGFloat tmpSize;
}

@property (nonatomic, retain) NSMutableArray *dataSource;
@property (nonatomic, retain) UITableView *tableView;

@end

@implementation DJMineController

//记录选中的cell
static NSInteger stateCell;
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    CGRect frame = self.tableView.frame;
    frame.origin.y = (kScreenHeight - (50 * 6 + 40)) / 2;
    self.tableView.frame = frame;
    
    tmpSize = [[SDImageCache sharedImageCache] checkTmpSize];
    
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[SDImageCache sharedImageCache] clearMemory];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    stateCell = 1;
    
    self.view.backgroundColor = [UIColor colorWithRed:45 / 255.0 green:30 / 255.0 blue:76 / 255.0 alpha:1.0];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (kScreenHeight - (50 * 6 + 60)) / 2, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self.tableView  registerClass:[DJMineCell class] forCellReuseIdentifier:@"mine"];
    [self.tableView  registerClass:[DJHeaderCell class] forCellReuseIdentifier:@"header"];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self readDataByPlist];
    [self clipExtraCellLine];
}
- (void)readDataByPlist
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"MyselfList" ofType:@"plist"];
    NSArray *dataArr = [NSArray arrayWithContentsOfFile:filePath];
    self.dataSource = [NSMutableArray array];
    for (NSDictionary *dic in dataArr) {
        MineModel *model = [MineModel mineModelWithDic:dic];
        
        [self.dataSource addObject:model];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView setSeparatorColor:[UIColor clearColor]];
    [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:stateCell inSection:0] animated:YES scrollPosition:UITableViewScrollPositionBottom];
    if (indexPath.row == 0)
    {
        tableView.rowHeight = 60;
        DJHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"header" forIndexPath:indexPath];
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        tableView.rowHeight = 50;
        DJMineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mine" forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        [cell configureWithMineModel:self.dataSource[indexPath.row]];
        if (indexPath.row == 3)
        {
            cell.lblCacheSize.text = tmpSize >= 1 ? [NSString stringWithFormat:@"%.2fM",tmpSize] : [NSString stringWithFormat:@"%.2fK",tmpSize * 1024];
            [cell addSubview:cell.lblCacheSize];
        }
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    stateCell = indexPath.row;
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    DDMenuController *menuC  = delegate.menuController;
    MyTabBarViewController *tab = [[MyTabBarViewController alloc] init];
    [tab configureTapBarItem];
    
    UINavigationController *nav = nil;
    switch (indexPath.row) {
        case 0:
        case 1: {
            DJNewsViewController *new = [[DJNewsViewController alloc] init];
            [self.navigationController pushViewController:new animated:YES];
            [menuC setRootController:tab animated:YES];
            break;
        }
        case 2: {
            DJFavoriteController *fController = [[DJFavoriteController alloc] init];
            nav = [[UINavigationController alloc] initWithRootViewController:fController];
            [self.navigationController pushViewController:fController animated:YES];
            [menuC setRootController:nav animated:YES];

            break;
        }
        case 3:
            [self clearCache];
            break;
        case 4: {
            DJSuggestController *sController = [[DJSuggestController alloc] init];
            nav = [[UINavigationController alloc] initWithRootViewController:sController];
            [menuC setRootController:nav animated:YES];

            break;
        }
        case 5: {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"免责声明" message:@"本APP旨在技术分享，不涉及任何商业利益。" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *act1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            
            [alert addAction:act1];
            [self presentViewController:alert animated:YES completion:nil];

            break;
        }
        case 6: {
            UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:@"关于我们" message:@"我们是大江文化团队，专注开发iOS应用\n团队成员：刘文江 \n邮   箱：464280789@qq.com" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *act2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            
            [alert1 addAction:act2];
            [self presentViewController:alert1 animated:YES completion:nil];

            break;
        }
        default:
            
            break;
    }
    
    
}

#pragma mark -method
//清楚缓存
- (void)clearCache {
    
    if (tmpSize <= 0.0)
    {
        UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:@"暂无缓存" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *act2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        
        [alert1 addAction:act2];
        [self presentViewController:alert1 animated:YES completion:nil];
        return;
    }
    
    UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:@"真的要清除吗" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *act1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *act2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        MBProgressHUD *hud = [[MBProgressHUD alloc] init];
        [self.view addSubview:hud];
        //加载条上显示文本
        hud.labelText = @"急速清理中";
        //置当前的view为灰度
        hud.dimBackground = YES;
        //设置对话框样式
        hud.mode = MBProgressHUDModeDeterminate;
        [hud showAnimated:YES whileExecutingBlock:^{
            while (hud.progress < 1.0) {
                hud.progress += 0.01;
                [NSThread sleepForTimeInterval:0.02];
            }
            hud.labelText = @"清理完成";
        } completionBlock:^{
            [[SDImageCache sharedImageCache] clearDisk];
            [[SDImageCache sharedImageCache] clearMemory];
            tmpSize = 0.0;
            [self.tableView reloadData];
            [hud removeFromSuperview];
        }];
    
    }];
    [alert1 addAction:act1];
    [alert1 addAction:act2];
    [self presentViewController:alert1 animated:YES completion:nil];
    
    
}

#pragma mark - 去处多余的分割线
- (void)clipExtraCellLine
{
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footerView;

}

@end
