//
//  DJPictureViewController.m
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/7.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import "DJPictureViewController.h"
#import "DJCollectionViewFlowLayout.h"
#import "DJPictureDetailViewController.h"
#import "DJPictureModel.h"
#import "DJNetWork.h"
#import "DJPictureView.h"
#import "AppDelegate.h"

@interface DJPictureViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,DJCollectionViewFlowLayout>
{
    NSMutableArray *dataSource; //数据源
    UICollectionView *DJCollectionView;
    
}
@property (nonatomic, copy) NSString *setid;
@end

@implementation DJPictureViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //读取数据
    [self readData:kURL_Start];
    
    [self configureLeftButton];
    
    [self flowLayoutInit];
    
    [self refreshDown];
    
    [self loadMoreUp];
    
}

#pragma mark - 上拉刷新
//下拉刷新
- (void)refreshDown {
    // 添加传统的下拉刷新

    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    DJCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    [DJCollectionView.mj_header beginRefreshing];
}

//下拉刷新
- (void)loadNewData
{
    [self readData:kURL_Start];
    // 拿到当前的下拉刷新控件，结束刷新状态
    [DJCollectionView.mj_header endRefreshing];
    
}

#pragma mark - 上拉刷新
- (void)loadMoreUp {
    // 添加传统的上拉刷新
    DJCollectionView.mj_footer = [MJRefreshBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];

    [DJCollectionView.mj_header beginRefreshing];
}

//上拉刷新
- (void)loadMoreData
{
    [self readData:[NSString stringWithFormat:kURL_More,self.setid]];
    [DJCollectionView.mj_footer endRefreshing];
}

#pragma mark - UICollectionViewDataSource
//设置item的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return dataSource.count;
}

//针对于每个item返回cell对象
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DJPictureView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DJPictureView" forIndexPath:indexPath];
    DJPictureModel *model = dataSource[indexPath.item];
    [cell configureSubviews:model];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
//item选中事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DJPictureDetailViewController *pic = [[DJPictureDetailViewController alloc] init];
    DJPictureModel *model = dataSource[indexPath.row];
    
    pic.skipID = model.setid;
    self.navigationController.navigationBarHidden = YES;
    [self setHidesBottomBarWhenPushed:YES];//隐藏tabbar
    [self.navigationController pushViewController:pic animated:YES];
    [self setHidesBottomBarWhenPushed:NO];//显示tabbar
}
#pragma mark - DJCollectionViewFlowLayout
//动态返回每个item的高度
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(DJCollectionViewFlowLayout *)layout heightForItemAtIndexPath:(NSIndexPath *)indexpath{
    //根据对应的Model对象, 动态计算出每个item的高度,
    //按比例进行缩放,得到最终缩放之后的高度,返回
    DJPictureModel *model = dataSource[indexpath.item];
    return [DJPictureView heightForRowWithDic:(DJPictureModel *)model];
}
#pragma mark - 读取数据
- (void)readData:(NSString *)url
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
    
        [DJNetWork JSONDataWithURL:url success:^(id data) {
            
            dataSource = [NSMutableArray array];
            //换类型之前，移除上一次的数据
            if ([url isEqualToString:kURL_Start]) {
                [dataSource removeAllObjects];
            }
            
            NSArray *arr = [NSArray arrayWithArray:data];
            for (NSDictionary *dict in arr)
            {
                DJPictureModel *model = [[DJPictureModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                
                if ([DJNetWork okPass:model.desc])
                {
                    [dataSource addObject:model];
                }
                
                self.setid = model.setid;
            }

            
            //刷新数据
            dispatch_async(dispatch_get_main_queue(), ^{
                [DJCollectionView reloadData];
            });
            
        } fail:^{
            MBProgressHUD *mb = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            mb.mode = MBProgressHUDModeText;
            mb.labelText = @"网络不给力呀";
            [mb hide:YES afterDelay:0.5];
            
        }];
    });
}

#pragma mark - 网格的初始化
//网格的初始化
- (void)flowLayoutInit
{
    DJCollectionViewFlowLayout *flowLayout = [[DJCollectionViewFlowLayout alloc] init];
    //设置item的宽度
    flowLayout.itemWidth = (kScreenWidth - 15) / 2;
    
    //设置每个分区的缩进量
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    
    //设置代理
    flowLayout.delegate = self;
    
    //设置最小行间距
    flowLayout.minLineSpacing = 15;
    
    //列数
    flowLayout.columnCount = 2;
    
    //网格初始化
    DJCollectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:flowLayout];
    
    //签代理
    DJCollectionView.dataSource = self;
    DJCollectionView.delegate = self;
    
    //设置背景色
    DJCollectionView.backgroundColor = [UIColor whiteColor];
    
    //注册标识符
    [DJCollectionView registerClass:[DJPictureView class] forCellWithReuseIdentifier:@"DJPictureView"];
    
    [self.view addSubview:DJCollectionView];
}
#pragma mark - 界面配置类
- (void)configureLeftButton
{
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"qr_toolbar_more_hl"] style:UIBarButtonItemStylePlain target:self action:@selector(handleBack:)];
    self.navigationItem.leftBarButtonItem = left;
    
}

- (void)handleBack:(UIBarButtonItem *)item {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    DDMenuController *menuC  = delegate.menuController;
    [menuC showLeftController:YES];
}

@end
