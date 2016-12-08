//
//  DJVideoController.m
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/7.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import "DJVideoController.h"
#import "DJVideoTwoCell.h"

#import "AppDelegate.h"
#import "DJVideoModel.h"
#import "DJVideoCell.h"
#import "NSTimer+DJControl.h"
#import "DJVideoDetailController.h"
#import "DJData.h"
#import "DJNetWork.h"
#import "DDMenuController.h"
#import "FavoriteModel.h"



@interface DJVideoController ()<UIActionSheetDelegate>
{
    NSInteger index;
    MJRefreshNormalHeader *header;

}
@property (nonatomic, retain) NSMutableArray *dataSource;
@property (nonatomic, retain) DJVideoCell *tempCell;
@property (nonatomic, retain) DJVideoTwoCell *tempTwoCell;
@property (nonatomic, retain) DJVideoCell *tempCurrentCell;
@property (nonatomic, retain) NSIndexPath *selectIndexPath;

@end

@implementation DJVideoController

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        self.dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.tempCurrentCell.player pause];
        
    self.tempCurrentCell.startButton.hidden = NO;

    [self.tableView reloadData]; //让剩余时间复位
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureLeftButton];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    
    // 马上进入刷新状态
    [header beginRefreshing];
    
    // 设置header
    self.tableView.mj_header = header;
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    // 设置了底部inset
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
    // 忽略掉底部inset
    self.tableView.mj_footer.ignoredScrollViewContentInsetBottom = 30;

    [self readVidesData];
}

//下拉刷新
- (void)loadNewData
{
    index = 20;
    
    [self readVidesData];
    // 拿到当前的下拉刷新控件，结束刷新状态
    [self.tableView.mj_header endRefreshing];
    
}

//上拉刷新
- (void)loadMoreData
{
    index += 20;
    
    [self readVidesData];
    // 拿到当前的上拉刷新控件，结束刷新状态
    [self.tableView.mj_footer endRefreshing];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //解决cell的重用问题
    NSString *iden = [NSString stringWithFormat:@"cell%ld%ld",indexPath.section,indexPath.row];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 9.0)
    {
        DJVideoTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        
        if (cell == nil)
        {
            cell = [[DJVideoTwoCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:iden];
        }
        DJVideoModel *model = self.dataSource[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = model;
        cell.btnMoreBlock = ^(DJVideoTwoCell *twoCell)
        {
            self.tempTwoCell = twoCell;
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"收藏" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self saveFavorite];
                
            }];
            
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                
            }];
            
            [alert addAction:action];
            [alert addAction:action1];
            
            [self presentViewController:alert animated:YES completion:^{
                
                
            }];
            
        };
        
        return cell;
        
    }
    else
    {
        DJVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (!cell)
        {
            cell = [[DJVideoCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:iden];
        }
        DJVideoModel *model = self.dataSource[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = model;
        cell.btnMoreBlock = ^(DJVideoCell *c)
        {
            self.tempCell = c;
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"收藏" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self saveFavorite];
                
            }];
            
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                
            }];
            
            [alert addAction:action];
            [alert addAction:action1];
            
            [self presentViewController:alert animated:YES completion:^{
                
                
            }];
            
        };
        
        cell.TapBlock = ^(DJVideoCell *vc) {
            //上一个播放的
            if (self.tempCurrentCell)
            {
                self.tempCurrentCell.startButton.hidden = NO;
            }
            self.tempCurrentCell = vc;
            
            self.selectIndexPath = indexPath;
        };
        return cell;
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DJVideoDetailController *vdc = [[DJVideoDetailController alloc] init];
    vdc.model = self.dataSource[indexPath.row];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 9.0)
    {
        
    }
    else
    {
        [self.tempCurrentCell.player pause];
    }
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vdc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DJVideoModel *model = self.dataSource[indexPath.row];
    return [DJVideoCell heightCell:model];
}

#pragma mark - 数据类

//读取数据
- (void)readVidesData
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        NSString *str = [NSString stringWithFormat:kURL_Video,index];
        [DJNetWork JSONDataWithURL:str success:^(id data) {
            if (self.dataSource)
            {
                [self.dataSource removeAllObjects];
            }
            NSArray *arr = data[@"list"];
            for (NSDictionary *dict in arr)
            {
                DJVideoModel *model = [[DJVideoModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.dataSource addObject:model];
            }
            //刷新数据之前，把正在播放的视频停掉
            if (self.tempCurrentCell)
            {
                [self.tempCurrentCell.player stop];
            }
            
            //刷新数据
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });

            
        } fail:^{
            MBProgressHUD *mb = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            mb.mode = MBProgressHUDModeText;
            mb.labelText = @"网络不给力呀";
            [mb hide:YES afterDelay:0.5];
            
        }];
    });
    
    

}

#pragma mark - 界面配置类
- (void)configureLeftButton
{
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"qr_toolbar_more_hl"] style:UIBarButtonItemStylePlain target:self action:@selector(handleBack:)];
    self.navigationItem.leftBarButtonItem = left;
}
- (void)handleBack:(UIBarButtonItem *)item
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    DDMenuController *menuC  = delegate.menuController;
    [menuC showLeftController:YES];

}

#pragma mark - 收藏
- (void)saveFavorite {
    FavoriteModel *fmodel = [[FavoriteModel alloc] init];
    fmodel.ftitle = self.tempCell.model.text;
    fmodel.flag = @"VIDEOS";
    fmodel.furl = self.tempCell.model.videouri;
    
    //存假值，用的时候，在取出来
    NSMutableArray *array = [NSMutableArray arrayWithObjects:self.tempCell.model.image_small, self.tempCell.model.width, self.tempCell.model.height, self.tempCell.model.name, self.tempCell.model.profile_image, self.tempCell.model.videotime, self.tempCell.model.playcount, @(self.tempCell.model.ID) , nil];
    
    fmodel.fboardid = [array componentsJoinedByString:@"@$%"];
    
    MBProgressHUD *hud= [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    [[DJData shareData] openDataBase];
    
    if ([[DJData shareData] insertData:fmodel]) {
        //加载条上显示文本
        hud.labelText = @"收藏成功";
    } else {
        hud.labelText = @"已经收藏";
    }
    
    [[DJData shareData] closeDataBase];
    //置当前的view为灰度
    hud.dimBackground = YES;
    //设置对话框样式
    hud.mode = MBProgressHUDModeText;
    [hud showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    } completionBlock:^{
        [hud removeFromSuperview];
    }];
}

//停掉不在可视范围内的视频
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.tempCurrentCell)
    {
        DJVideoModel *model = self.dataSource[self.selectIndexPath.row];
        CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:self.selectIndexPath];
        CGRect rectInWindow = [self.tableView convertRect:rectInTableView toView:[self.tableView superview]];
        //判断是否超出屏幕范围
        if (rectInWindow.origin.y <= [DJVideoCell heightCell:model] || rectInWindow.origin.y >=  kScreenHeight)
        {
            [self.tempCurrentCell.player pause];
        }
    }
}
@end
