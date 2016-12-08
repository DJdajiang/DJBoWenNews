
//
//  DJCommentViewController.m
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/14.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import "DJCommentViewController.h"
#import "DJCommentModel.h"
#import "DJCommentCell.h"
#import "AppDelegate.h"
#import "DDMenuController.h"
#import "DJNetWork.h"

@interface DJCommentViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _count;
    UITableView *table;
    NSMutableArray *dataSource;
}
@end

@implementation DJCommentViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    DDMenuController *menuC  = delegate.menuController;
    [menuC setEnableGesture:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    table.dataSource = self;
    table.delegate = self;
    [table registerClass:[DJCommentCell class] forCellReuseIdentifier:@"comment"];
    [self.view addSubview:table];
    dataSource = [NSMutableArray array];
    
    [self configureNavView];
    [self readDataByURL];
    [self refreshDown];
    [self loadMoreUp];
    
    self.navigationController.automaticallyAdjustsScrollViewInsets  = NO;

}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSource.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DJCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"comment" forIndexPath:indexPath];
    //去掉cell的点击效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    DJCommentModel *model = dataSource[indexPath.row];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DJCommentModel *model = dataSource[indexPath.row];
    return [DJCommentCell heightForRowWithDic:model];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

#pragma mark - 视图配置
//配置导航栏
- (void)configureNavView
{
    //将导航条显示出来
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"个性评论区";
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(handleLeft:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
}

//点击返回按钮
- (void)handleLeft:(UIBarButtonItem *)item
{
    if ([self.flag isEqualToString:@"photoview_bbs"]) {
        self.navigationController.navigationBarHidden = YES; //判断是不是ImagesDisplayController push过来的，如果是，pop之前将导航条隐藏
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 数据配置
- (void)readDataByURL
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        
        
        [DJNetWork JSONDataWithURL:[NSString stringWithFormat:kURLNew,self.flag, self.docid, (long)_count] success:^(id data){

            if (!_count)
            {
                [dataSource removeAllObjects];
            }
            
            NSMutableArray *dataArr = data[@"newPosts"];
            if (![dataArr isKindOfClass:[NSNull class]])
            {
                for (NSDictionary *bigDict in dataArr)
                {
                    NSDictionary *dict = bigDict[@"1"];
                    DJCommentModel *model =[[DJCommentModel alloc] init];
                    [model setValuesForKeysWithDictionary:dict];
                    [dataSource addObject:model];
                    
                }
                //刷新数据
                dispatch_async(dispatch_get_main_queue(), ^{
                    [table reloadData];
                });
                
                
            }
        } fail:^{
            
            MBProgressHUD *mb = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            mb.mode = MBProgressHUDModeText;
            mb.labelText = @"网络不给力呀";
            [mb hide:YES afterDelay:0.5];
        }];
    });
}

//下拉刷新
- (void)refreshDown
{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    table.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    [table.mj_header beginRefreshing];
}

- (void)loadNewData
{
    _count = 0;
    [self readDataByURL];
    
    [table.mj_header endRefreshing];
}

//上拉刷新
- (void)loadMoreUp
{
    table.mj_footer = [MJRefreshBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    [table.mj_header beginRefreshing];
}

- (void)loadMoreData
{
    _count += 11;
    [self readDataByURL];
    
    [table.mj_footer endRefreshing];
}
@end
