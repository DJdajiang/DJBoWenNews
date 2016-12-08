//
//  DJNewsViewController.m
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/7.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import "DJNewsViewController.h"
#import "DJCycleModel.h"
#import "DJCycleScrollView.h"
#import "AppDelegate.h"
#import "DJNetWork.h"
#import "DJReadDatailViewController.h"
#import "DJPictureDetailViewController.h"
#import "DJNavView.h"
#import "DJNewsModel.h"
#import "DJOneImageFirstCell.h"
#import "DJThreeImagesCell.h"
#import "DJBigImageCell.h"
#import "DJCommonCell.h"
#import "DJNavTypeTitleModel.h"

@interface DJNewsViewController ()<UITableViewDelegate,UITableViewDataSource,DJNavViewDelegate>
{
    NSInteger _count;//当前加载开始位置
}
@property (nonatomic, retain) NSMutableArray *dataSource; //存储数据
@property (nonatomic, retain) DJCycleScrollView *cycleView; //轮播图cell
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) DJNavView *navView;
@property (nonatomic, retain) NSString *typeKey;
@end

@implementation DJNewsViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self configureNav];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.fd_prefersNavigationBarHidden = YES;
    [self configureTableView];
    self.view.backgroundColor = [UIColor clearColor];
    self.typeKey = @"T1348647853363";
    [self configureCycleView];
    [self registerCell];
    [self refreshDown];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DJNewsModel *model = self.dataSource[indexPath.row];
    if (indexPath.row == 0) {
        if (![self.typeKey isEqualToString:@"T1348647853363"])
        {
            DJOneImageFirstCell *cell = [[DJOneImageFirstCell alloc] init];
            cell.model = model;
            tableView.rowHeight = 180;
            return cell;
        }
        else
        {
            tableView.rowHeight = 200;
            return self.cycleView;
        }
    }
    else
    {
        //如果是首页，需要将行减去1， 即除去轮播图
        if ([self.typeKey isEqualToString:@"T1348647853363"])
        {
            model = self.dataSource[indexPath.row - 1];
        }
        
        if (model.flag == 1) {
            DJThreeImagesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"images" forIndexPath:indexPath];
            tableView.rowHeight = 120;
            cell.model = model;
            return cell;
        }
        else if(model.flag == 2)
        {
            DJBigImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bigImage" forIndexPath:indexPath];
            tableView.rowHeight = 195;
            cell.model = model;
            return cell;
        }
        else
        {
            DJCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"common" forIndexPath:indexPath];
            tableView.rowHeight = 90;
            cell.model = model;
            
            return cell;
        }
    }
}

#pragma mark - UITableViewDeletage
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DJNewsModel *model = self.dataSource[indexPath.row];
    //如果是首页，需要将行减去1
    if ([self.typeKey isEqualToString:@"T1348647853363"])
    {
        model = self.dataSource[indexPath.row - 1];
    }
    
    //imgextra和photoset
    if (model.isPhotoset)
    {
        [self pushImagesDisplayController:model key:0];
    }
    else
    {
        DJReadDatailViewController *read = [[DJReadDatailViewController alloc] init];
        read.docid = model.docid;
        read.newsTitle = model.title;
        read.flag = model.boardid;
        read.url_3w = model.url_3w;
        self.navView.hidden = YES;//隐藏自定义导航
        
        [self setHidesBottomBarWhenPushed:YES];//隐藏tabbar
        [self.navigationController pushViewController:read animated:YES];
        [self setHidesBottomBarWhenPushed:NO];

    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataSource.count - 1 == indexPath.row)
    {
        [self loadMoreUp];
    }
}

#pragma mark - NavViewDelegate action
//点击导航标题后的action
- (void)clickBtn:(UIButton *)btn typeModel:(DJNavTypeTitleModel *)typemodel navView:(DJNavView *)navView
{
    _count = 0;
    //换类型之前，移除上一次的数据
    [self.dataSource removeAllObjects];
    
    self.typeKey = typemodel.typeLinkID[btn.tag - 101];
    
    [self requestData:[NSString stringWithFormat:kURL_String,typemodel.typeLinkID[btn.tag - 101], (long)_count] key:self.typeKey];
    
    [self.tableView reloadData];
}

#pragma mark - method 私有方法
//配置tableView
- (void)configureTableView
{
    if (_tableView == nil)
    {
        self.tableView =[[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
        self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"博文新闻"]];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self.view addSubview:_tableView];
    }
}

//自定义导航
- (void)configureNav
{
    //如果存在，则不需要重新创建
    if (!_navView) {
        self.navView = [[DJNavView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    }
    _navView.hidden = NO;
    _navView.delegate = self;
    [self.view addSubview:_navView]; //添加到视图上
}

//配置轮播图
- (void)configureCycleView
{
    NSMutableArray *dataArray = [@[] mutableCopy];
    self.cycleView = [[DJCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200) animationDuration:2];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        [DJNetWork JSONDataWithURL:[NSString stringWithFormat:kURL_CYCLE, 5] success:^(id data) {
            NSArray *tempArr = [data objectForKey:@"headline_ad"];
            for (NSDictionary *dict in tempArr) {
                DJCycleModel *model = [[DJCycleModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                
                if ([model.url containsString:@"|"])
                {
                    [dataArray addObject:model];
                }
            }
            [self.cycleView setValueWithDataArr:dataArray];
            
            __weak DJNewsViewController *weakSelf = self;
            self.cycleView.TapActionBlock = ^(NSInteger pageIndex){
                DJCycleModel *model = (DJCycleModel *)dataArray[pageIndex];
                
                [weakSelf pushImagesDisplayController:model key:1];
            };
            
            
        } fail:^{
            
            
        }];

        
    });
}

- (void)pushImagesDisplayController:(id)model key:(NSInteger)key
{
    DJPictureDetailViewController *picture = [[DJPictureDetailViewController alloc] init];
    if (key == 0)
    {
        DJNewsModel  *nModel = (DJNewsModel *)model;
        //接口数据，有的带有 | 符号，在这处理一下
        if ([nModel.skipID containsString:@"|"]) {
            NSArray *IDs = [nModel.skipID componentsSeparatedByString:@"|"];
            if (IDs) {
                nModel.skipID = IDs[1];
                picture.skipTypeID = IDs[0];
            }
        }
        picture.skipID = nModel.skipID;
    }
    else
    {
        DJCycleModel *cModel = (DJCycleModel *)model;
        if ([cModel.url containsString:@"|"]) {
            NSArray *IDs = [cModel.url componentsSeparatedByString:@"|"];
            if (IDs) {
                cModel.url = IDs[1];
                picture.skipTypeID = IDs[0];
            }
        }
        picture.skipID = cModel.url;
    }
    self.navView.hidden = YES;
    [self setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:picture animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
    
}


//注册cell
- (void)registerCell
{
    [self.tableView registerClass:[DJCommonCell class] forCellReuseIdentifier:@"common"];
    [self.tableView registerClass:[DJThreeImagesCell class] forCellReuseIdentifier:@"images"];
    [self.tableView registerClass:[DJBigImageCell class] forCellReuseIdentifier:@"bigImage"];
}

#pragma mark - 数据类
//请求数据
- (void)requestData:(NSString *)urlString key:(NSString *)key
{
    if ([key isEqualToString: @"T1348647853363"])
    {
        urlString = [NSString stringWithFormat:kURL_NEWSLIST, (long)_count];
    }
    
    [DJNetWork JSONDataWithURL:urlString success:^(id data) {
        if (!_count) {
            [self.dataSource removeAllObjects];
        }
        NSArray *tempArr = [data objectForKey:key];
        for (NSDictionary *dict in tempArr) {
            DJNewsModel *model = [[DJNewsModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            if (model.imgextra) {
                model.flag = 1; //三张图片cell, //三张图片又是图片集
            }
            if (model.imgType == 1) {
                model.flag = 2; //一张大图cell
            }
            
            //图片集
            if (model.skipID && [model.skipType isEqualToString:@"photoset"]) {
                model.isPhotoset = YES;
            }
            //过滤掉的类别
            if (![model.TAGS isEqualToString:@"LIVE"] && ![model.TAGS isEqualToString:@"画报"] && !(model.editor && ![model.TAGS isEqualToString:@"独家"])) {
                
                if ([DJNetWork okPass:model.title])
                {
                    [self.dataSource addObject:model];
                }
            }
        }
        //需要重写加载数据
        [self.tableView reloadData];
        
    } fail:^{
        MBProgressHUD *mb = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        mb.mode = MBProgressHUDModeText;
        mb.labelText = @"网络不给力呀";
        [mb hide:YES afterDelay:0.5];
        
    }];

}
//下拉刷新
- (void)refreshDown
{
    // 添加传统的下拉刷新
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        
        _count = 0;
        [self requestData:[NSString stringWithFormat:kURL_String, self.typeKey, (long)_count] key:self.typeKey];
        [self.tableView.mj_header endRefreshing];
    }];
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}
- (void)loadMoreUp {
    // 添加传统的上拉刷新
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        _count += 20;
        [self requestData:[NSString stringWithFormat:kURL_String, self.typeKey, (long)_count] key:self.typeKey];
        
        [self.tableView.mj_footer endRefreshing];
        
    }];
    
    [self.tableView.mj_footer beginRefreshing];
}
#pragma mark lazy Loading
- (NSMutableArray *)dataSource
{
    if (!_dataSource)
    {
        self.dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


@end
