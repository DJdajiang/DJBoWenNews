//
//  DJReadViewController.m
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/7.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import "DJReadViewController.h"
#import "DJReadModel.h"
#import "DJReadViewCell.h"
#import "DJLeftoneRighttwoTableViewCell.h"
#import "DJNoimageTableViewCell.h"
#import "DJNetWork.h"
#import "DDMenuController.h"
#import "AppDelegate.h"
#import "DJReadDatailViewController.h"

#define kLeftIdentifier @"Left"  //左边一个图
#define kThreeImageIdentifier @"LeftOneRightTwo"   //左1右2
#define kNoIdentifier @"noImage"  //没有图片
#define kUpIdentifier @"Up"

@interface DJReadViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *table;
    NSMutableArray *dataSource;
    NSInteger count;
}
@end

@implementation DJReadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    table.dataSource = self;
    table.delegate = self;
    
    [self registerCell];
    
    table.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"博文新闻"]];
    [self.view addSubview:table];
    
    dataSource = [NSMutableArray array];
    
    count = 6;
    
    [self requestData];
    
    [self configureLeftButton];
    
    [self downRefresh];
    
    [self upRefresh];
}

//注册3套cell
- (void)registerCell {
    [table registerClass:[DJReadViewCell class] forCellReuseIdentifier:kLeftIdentifier];
    [table registerClass:[DJLeftoneRighttwoTableViewCell class] forCellReuseIdentifier:kThreeImageIdentifier];
    [table registerClass:[DJNoimageTableViewCell class] forCellReuseIdentifier:kNoIdentifier];
}

//下拉刷新
- (void)downRefresh
{
    table.mj_footer = [MJRefreshBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    [table.mj_footer beginRefreshing];
}

- (void)loadMoreData
{
    count += 6;
    
    [self requestData];
    
    [table.mj_footer endRefreshing];
}

//上拉刷新
- (void)upRefresh
{
    
    table.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    table.mj_header.automaticallyChangeAlpha = YES;
    
    // 马上进入刷新状态
    [table.mj_header beginRefreshing];
    
}

- (void)loadNewData
{
    count = 6;
    
    [self requestData];
    
    [table.mj_header endRefreshing];
}

//读取数据
- (void)requestData
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        [DJNetWork JSONDataWithURL:[NSString stringWithFormat:kReadAPI, (long)count] success:^(id data) {
            if (dataSource)
            {
                [dataSource removeAllObjects];
            }
            
            NSArray *arr = [data objectForKey:@"推荐"];
            
            for (NSDictionary *dic in arr)
            {
                DJReadModel *readNews = [[DJReadModel alloc] init];
                [readNews setValuesForKeysWithDictionary:dic];
                
                if (readNews.imgnewextra) {
                    readNews.flag = 3;// 标记三个图的cell
                } else if (readNews.imgsrc) {
                    readNews.flag = 1; // 标记一个图的cell
                } else {
                    readNews.flag = 0;  //标记没有图片的cell
                }
                if ([DJNetWork okPass:readNews.title])
                {
                    [dataSource addObject:readNews];
                }
   
            }
            
            [dataSource removeObject:dataSource[0]];
            //刷新数据
            [table reloadData];
            
        } fail:^{
            MBProgressHUD *mb = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            mb.mode = MBProgressHUDModeText;
            mb.labelText = @"网络不给力呀";
            [mb hide:YES afterDelay:0.5];
        }];
        
    }); 
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    DJReadModel *readNews = dataSource[indexPath.row];
    if (readNews.flag == 1) { //等于1 选择左边一个图的cell
        
        DJReadViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kLeftIdentifier forIndexPath:indexPath];
        //赋值
        [cell configureCellWithRead:readNews];
        
        return cell;
    } else if (readNews.flag == 0) {  //选择没有图的cell
        
        DJNoimageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNoIdentifier forIndexPath:indexPath];
        [cell configureCellWithRead:readNews];
        return cell;
    } else  { //选择三个图片的cell
        
        DJLeftoneRighttwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kThreeImageIdentifier forIndexPath:indexPath];
        [cell configureCellWithRead:readNews];
        return cell;
        
        
    }
}
#pragma mark - delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DJReadModel *model = dataSource[indexPath.row];
    
    if (model.flag ==1)
    {
        return [DJReadViewCell heightForRowWithReadNews:model];
    }
    else if (model.flag == 3)
    {
        return [DJLeftoneRighttwoTableViewCell heightForRowWithReadNews:model];;
    }
    else
    {
        return [DJNoimageTableViewCell heightForRowWithReadNews:model];
    }
}

//cell选中事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DJReadModel *model = dataSource[indexPath.row];
    DJReadDatailViewController *readDetail = [[DJReadDatailViewController alloc] init];
    readDetail.flag = model.boardid;
    readDetail.docid = model.docid;
    readDetail.newsTitle = model.title;
    readDetail.newsDegst = model.digest;
    readDetail.imageArray = [NSArray arrayWithObject:model.imgsrc];
    [self setHidesBottomBarWhenPushed:YES];//隐藏tabbar
    [self.navigationController pushViewController:readDetail animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
}

#pragma mark - 界面配置类
- (void)configureLeftButton {
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"qr_toolbar_more_hl"] style:UIBarButtonItemStylePlain target:self action:@selector(handleBack:)];
    self.navigationItem.leftBarButtonItem = left;
    
}
- (void)handleBack:(UIBarButtonItem *)item {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    DDMenuController *menuC  = delegate.menuController;
    [menuC showLeftController:YES];
}

@end
