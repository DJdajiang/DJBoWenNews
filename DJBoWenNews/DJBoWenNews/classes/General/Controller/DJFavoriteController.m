//
//  DJFavoriteController.m
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/18.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import "DJFavoriteController.h"
#import "DJFavoriteView.h"
#import "FavoriteModel.h"
#import "DJFavoriteCell.h"
#import "AppDelegate.h"
#import "DJData.h"
#import "DJPictureDetailViewController.h"
#import "DJReadDatailViewController.h"
#import "DJVideoDetailController.h"
#import "DDMenuController.h"
#import "DJVideoModel.h"

@interface DJFavoriteController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, retain) DJFavoriteView *rootView;
@property (nonatomic, retain) NSMutableArray *dataSource;

@end

@implementation DJFavoriteController

//在视图将要出现的时候，将平移手势去掉
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    DDMenuController *menuC  = delegate.menuController;
    [menuC setEnableGesture:NO];
   

}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_rootView.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的收藏";
    [self configureLeftButton];
    self.rootView = [[DJFavoriteView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = _rootView;
    _rootView.tableView.dataSource = self;
    _rootView.tableView.delegate = self;
    [_rootView.tableView registerClass:[DJFavoriteCell class] forCellReuseIdentifier:@"favorite"];
    [self readDataByDB];

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DJFavoriteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"favorite" forIndexPath:indexPath];
    FavoriteModel *model = self.dataSource[indexPath.row];
    
    
    if ([model.flag  isEqualToString:@"NEWS"])
    {
        cell.lblTag.text = @"【文】";
        cell.lblTag.textColor = [UIColor colorWithRed:35 / 255.0 green:141 / 255.0 blue:255 / 255.0 alpha:1.0];
    }
    else if ([model.flag isEqualToString:@"VIDEOS"])
    {
        cell.lblTag.text = @"【视】";
        cell.lblTag.textColor = [UIColor greenColor];
    }
    else
    {
        cell.lblTag.text = @"【图】";
        cell.lblTag.textColor = [UIColor redColor];
    }
    cell.lblTitle.text = model.ftitle;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

//提交编辑操作， 处理点击删除按钮之后的事件。
//删除收藏
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[DJData shareData] openDataBase];
    //删除对应的单元格的数据
    FavoriteModel *model = self.dataSource[indexPath.row];
    
    [[DJData shareData] deleteData:model.fid];
    
    [self.dataSource removeObject:model];
    
    [[DJData shareData] closeDataBase];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
}
//修改cell默认删除按钮的文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath :( NSIndexPath *)indexPath
{
    return @"删除";
}
//选中后
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FavoriteModel *model = self.dataSource[indexPath.row];
    if ([model.flag  isEqualToString:@"NEWS"])
    {
        DJReadDatailViewController *read= [[DJReadDatailViewController alloc] init];
        read.docid = model.fdocid;
        read.newsTitle = model.ftitle;
        read.flag = model.fboardid;
        [self.navigationController pushViewController:read animated:YES];

    }
    else if ([model.flag isEqualToString:@"VIDEOS"])
    {
        DJVideoDetailController *vdc = [[DJVideoDetailController alloc] init];
        DJVideoModel *vmodel = [[DJVideoModel alloc] init];
        vmodel.text = model.ftitle;
        vmodel.videouri = model.furl;
        
        NSArray  *temp = [model.fboardid componentsSeparatedByString:@"@$%"];
        vmodel.image_small = temp[0];
        vmodel.width = temp[1];
        vmodel.height = temp[2];
        vmodel.name = temp[3];
        vmodel.profile_image = temp[4];
        vmodel.videotime = temp[5];
        vmodel.playcount = temp[6];
        vmodel.ID = [temp[7] integerValue];
        
        vdc.model = vmodel;
        
        [self.navigationController pushViewController:vdc animated:YES];

    }
    else if([model.flag isEqualToString:@"PICTURES"])
    {
        DJPictureDetailViewController *picture = [[DJPictureDetailViewController alloc] init];
        picture.skipID = model.fdocid;
        picture.Furl = model.furl;
        self.navigationController.navigationBarHidden = YES;
        [self.navigationController pushViewController:picture animated:YES];
    }
    
    
}

#pragma mark - 界面配置类
- (void)configureLeftButton
{
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"qr_toolbar_more_hl"] style:UIBarButtonItemStylePlain target:self action:@selector(handleBack:)];
    self.navigationItem.leftBarButtonItem = left;
}

#pragma  mark - 数据类
- (void)readDataByDB
{
    [[DJData shareData] openDataBase];
    self.dataSource = [[DJData shareData] getListData];
    
    [self.rootView.tableView reloadData];
    
    [[DJData shareData ] closeDataBase];
}



#pragma mark -action

- (void)handleBack:(UIBarButtonItem *)item
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    DDMenuController *menuC  = delegate.menuController;
    [menuC showLeftController:YES];
}


#pragma  mark - lazying load
- (NSMutableArray *)dataSource
{
    if (!_dataSource)
    {
        self.dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
