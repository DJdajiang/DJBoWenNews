//
//  DJVideoDetailController.m
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/7.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import "DJVideoDetailController.h"
#import "DJNetWork.h"
#import "DJVideoDetailModel.h"
#import "DJVideoCell.h"
#import "DJVideoDetailCell.h"
#import "FavoriteModel.h"
#import "MBProgressHUD.h"
#import "DJData.h"
#import "DJVideoTwoCell.h"



@interface DJVideoDetailController ()
{
    NSInteger _count;
    NSInteger _total; //总的评论数
    AVPlayerLayer *playerLayer;
    NSString *videoURL;
    BOOL ka;
}
@property (nonatomic, retain) NSMutableArray *dataSource;
@property (nonatomic, retain) DJVideoTwoCell *tempTwoCell;
@property (nonatomic, retain) DJVideoCell *tempCell;
@property (nonatomic, retain) DJVideoCell *tempCurrentCell;
@end

@implementation DJVideoDetailController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [playerLayer.player pause];
}

//- (void)viewDidDisappear:(BOOL)animated
//{
//    [super viewDidDisappear:YES];
//    [playerLayer.player pause];
//}
- (void)viewDidLoad
{
    [super viewDidLoad];
    _count = 20;
    [self readVideoComment];
    
    ka=YES;
    self.navigationItem.title = @"评论";
    self.view.backgroundColor = [UIColor whiteColor];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return section == 0 ? 1 : self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0)
    {
        static NSString *identifier = @"vidoes";
        if ([[[UIDevice currentDevice] systemVersion] floatValue] > 9.0)
        {
            DJVideoTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (cell == nil)
            {
                cell = [[DJVideoTwoCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
            }
            
            DJVideoModel *model = self.model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.model = model;
            
            videoURL = cell.videoUrl;
            
            playerLayer = [AVPlayerLayer playerLayerWithPlayer:[AVPlayer playerWithURL:[NSURL URLWithString:cell.videoUrl]]];
            
            playerLayer.frame = cell.tempImage.frame;
            
            
            [cell.layer addSublayer:playerLayer];
            
            cell.imageName.alpha = 0;
            
            cell.btnMoreBlock = ^(DJVideoTwoCell *c) {
                self.tempTwoCell = c;
                
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"收藏" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self saveFavorite];
                    
                }];
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:nil message:@"暂不支持视频分享" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action5 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                        
                    }];
                    
                    [alert1 addAction:action5];
                    
                    [self presentViewController:alert1 animated:YES completion:^{
                        
                    }];
                    
                }];
                
                UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                    
                }];
                
                [alert addAction:action];
                [alert addAction:action1];
                [alert addAction:action2];
                
                [self presentViewController:alert animated:YES completion:^{
                    
                    
                }];
            };
            
            return cell;
        }
        else
        {
            DJVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell)
            {
                cell = [[DJVideoCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
            }
            
            DJVideoModel *model = self.model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.model = model;
            
            cell.btnMoreBlock = ^(DJVideoCell *c) {
                self.tempCell = c;
                
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"收藏" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self saveFavorite];
                    
                }];
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:nil message:@"暂不支持视频分享" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action5 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                        
                    }];
                    
                    [alert1 addAction:action5];
                    
                    [self presentViewController:alert1 animated:YES completion:^{
                    
            
                    }];

                }];
                
                UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                    
                }];
                
                [alert addAction:action];
                [alert addAction:action1];
                [alert addAction:action2];
                
                [self presentViewController:alert animated:YES completion:^{
                    
                    
                }];
            };
            
            cell.TapBlock = ^(DJVideoCell *vc) {
                self.tempCurrentCell = vc;
            };
            
            return cell;
        }
    }
    else
    {
        static NSString *iden2 = @"vcomment";
        DJVideoDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:iden2];
        if (!cell)
        {
            cell = [[DJVideoDetailCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:iden2];
        }
        
        DJVideoDetailModel *model = self.dataSource[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = model;
        return cell;
    }
}

#pragma mark - 收藏
- (void)saveFavorite
{
    [[DJData shareData] openDataBase];
    FavoriteModel *fmodel = [[FavoriteModel alloc] init];
    fmodel.ftitle = self.tempCell.model.text;
    fmodel.flag = @"VIDEOS";
    fmodel.furl = self.tempCell.model.videouri;
    
    //存假值，用的时候，在取出来
    NSMutableArray *array = [NSMutableArray arrayWithObjects:self.tempCell.model.image_small, self.tempCell.model.width, self.tempCell.model.height, self.tempCell.model.name, self.tempCell.model.profile_image, self.tempCell.model.videotime, self.tempCell.model.playcount, @(self.tempCell.model.ID) , nil];
    fmodel.fboardid = [array componentsJoinedByString:@"@$%"];
    
    MBProgressHUD *hud= [[MBProgressHUD alloc] init];
    [self.view addSubview:hud];
    if ([[DJData shareData] insertData:fmodel]) {
        //加载条上显示文本
        hud.labelText = @"收藏成功";
    } else {
        hud.labelText = @"已经收藏";
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        DJVideoModel *model =  self.model;
        return [DJVideoCell heightCell:model];
    }
    else
    {
        DJVideoDetailModel *model = self.dataSource[indexPath.row];
        return [DJVideoDetailCell heightCell:model];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == self.dataSource.count - 1)
    {
        // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        // 设置了底部inset
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
        // 忽略掉底部inset
        self.tableView.mj_footer.ignoredScrollViewContentInsetBottom = 30;
        
    }
}

- (void)loadMoreData
{
    _count += 20;
    
    [self readVideoComment];
    if (_count >= _total)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
        });
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
        UIButton *startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        startButton.frame = CGRectMake(30, 2, self.view.frame.size.width - 60, 36);
        
        
        [startButton setTitle:@"播放" forState:UIControlStateNormal];
        
        [startButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        startButton.backgroundColor = [UIColor greenColor];
        
        startButton.layer.masksToBounds = YES;
        startButton.layer.cornerRadius = 8;
        
        [startButton addTarget:self action:@selector(clickStartButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [view addSubview:startButton];
        return view;
    }
    else
    {
        return nil;
    }
}
- (void)clickStartButton:(UIButton *)button
{
    
    if (ka==YES)
    {
        [playerLayer.player play];
        
        ka =! ka;
    }
    else
    {
        [playerLayer.player pause];
        ka =! ka;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 40;
    }
    else
    {
        return 0;
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return section == 0 ? @"" : @"最新评论";
}


#pragma mark - 数据类
- (void)readVideoComment
{
    [DJNetWork JSONDataWithURL:[NSString stringWithFormat:kURL_Comment, (long)self.model.ID, (long)_count] success:^(id data) {
        if (self.dataSource) {
            [self.dataSource removeAllObjects];
        }
        NSArray *dataArr = data[@"data"];
        _total = [data[@"total"] integerValue];
        for (NSDictionary *dict in dataArr)
        {
            DJVideoDetailModel *model = [[DJVideoDetailModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [self.dataSource addObject:model];
        }
        //刷新数据
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadSections:[[NSIndexSet alloc]initWithIndex:1]withRowAnimation:UITableViewRowAnimationAutomatic];
        });
        
    } fail:^{
        
        
    }];
}


#pragma mark - 懒加载
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        self.dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

#pragma mark - 分享视频
- (void)shareVideo
{
    //1、构造分享内容
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params SSDKSetupFacebookMessengerParamsByImage:nil gif:nil audio:nil video:[NSURL URLWithString:videoURL] type:SSDKContentTypeVideo];
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
