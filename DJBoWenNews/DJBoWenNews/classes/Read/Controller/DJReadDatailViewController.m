//
//  DJReadDatailViewController.m
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/14.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import "DJReadDatailViewController.h"
#import "DJReadDetailView.h"
#import "AppDelegate.h"
#import "DDMenuController.h"
#import "DJNetWork.h"
#import "FavoriteModel.h"
#import "DJData.h"
#import "DJCommentViewController.h"

@interface DJReadDatailViewController ()

@property (nonatomic,retain) DJReadDetailView *readDetail;

@end

@implementation DJReadDatailViewController

- (void)loadView {
    [super loadView];
    self.readDetail = [[DJReadDetailView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = _readDetail;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    DDMenuController *menuC  = delegate.menuController;
    [menuC setEnableGesture:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;
    
    [self configureNavView];
    [self requestDetails];
    
    [self.readDetail.btnComment addTarget:self action:@selector(handleClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.readDetail.btnSave addTarget:self action:@selector(handleSave:) forControlEvents:UIControlEventTouchUpInside];
    [self.readDetail.btnShare addTarget:self action:@selector(handleShare:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 请求数据
//请求数据
- (void)requestDetails
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        
        [DJNetWork JSONDataWithURL:[NSString stringWithFormat:kUrlReadDetails,self.docid] success:^(id data)
        {
            
            NSDictionary *dataDict = [data objectForKey:self.docid];
            DJReadDetailModel *model= [[DJReadDetailModel alloc] init];
            [model setValuesForKeysWithDictionary:dataDict];
            self.readDetail.model = model;
            
        } fail:^{
            
            
        }];
    });
}

//配置导航栏
- (void)configureNavView {
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(handleLeft:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.title = self.newsTitle;
    [self.tabBarController removeFromParentViewController];
    
}

//点击返回按钮
- (void)handleLeft:(UIBarButtonItem *)item {
    //将tabbar显示出来
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

//点击评论按钮
- (void)handleClick:(UIButton *)sender
{
    DJCommentViewController *commentController = [[DJCommentViewController alloc] init];
    commentController.docid = self.docid;
    commentController.flag = self.flag; //评论标识
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:commentController animated:YES];

}
//点击收藏按钮
- (void)handleSave:(UIButton *)sender
{
    [[DJData shareData] openDataBase];
    FavoriteModel *fmodel = [[FavoriteModel alloc] init];
    fmodel.ftitle = self.newsTitle;
    fmodel.furl = [NSString stringWithFormat:kUrlReadDetails, self.docid];
    fmodel.fdocid = self.docid;
    fmodel.fboardid = self.flag;
    fmodel.flag = @"NEWS";
    MBProgressHUD *hud= [[MBProgressHUD alloc] init];
    [self.view addSubview:hud];
    
    BOOL ka = [[DJData shareData] insertData:fmodel];
    
    if (ka == YES)
    {
        //加载条上显示文本
        hud.labelText = @"收藏成功";
    }
    else
    {
        hud.labelText =  [fmodel.ftitle isEqualToString:@""] || !fmodel.ftitle ? @"加载完成才能收藏哦？" : @"已经收藏";
    }
    //置当前的view为灰度
    hud.dimBackground = YES;
    //设置对话框样式
    hud.mode = MBProgressHUDModeText;
    [hud showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    } completionBlock:^{
        [hud removeFromSuperview];
    }];
    
    [[DJData shareData] closeDataBase];

    
}
//分享
- (void)handleShare:(UIButton *)sender
{
    //1、构造分享内容
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params SSDKSetupShareParamsByText:self.newsDegst
                                images:self.imageArray
                                   url:[NSURL URLWithString:[NSString stringWithFormat:kUrlReadDetails,self.docid]]
                                 title:self.newsTitle
                                  type:SSDKContentTypeImage];
    [params SSDKEnableUseClientShare];
    
    [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                             items:nil
                       shareParams:params
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   MBProgressHUD *hud= [[MBProgressHUD alloc] init];
                   [self.view addSubview:hud];
                   if (state == SSDKResponseStateSuccess)
                   {
                       hud.labelText = @"分享成功";
                   }
                   else if (state == SSDKResponseStateFail)
                   {
                       hud.labelText = @"分享失败";
                   }
                   hud.mode = MBProgressHUDModeText;
                   [hud showAnimated:YES whileExecutingBlock:^{
                       sleep(1);
                   } completionBlock:^{
                       [hud removeFromSuperview];
                   }];
                   
               }
     ];
    
}
@end
