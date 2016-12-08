//
//  DJPictureDetailViewController.m
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/12.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import "DJPictureDetailViewController.h"
#import "DJData.h"
#import "DJNetWork.h"
#import "DJPictureDetailModel.h"
#import "DJPictureDetailView.h"
#import "UIImageView+WebCache.h"
#import "FavoriteModel.h"
#import "DJNetWork.h"
#import "AppDelegate.h"
#import "DJIndexScrollView.h"
#import "DJCommentViewController.h"

@interface DJPictureDetailViewController ()<UIScrollViewDelegate>
{
    NSInteger _pindex;
}
@property (nonatomic, retain) DJPictureDetailView *pictureDetailView;
@property (nonatomic, retain) NSMutableArray *photosData;
@property (nonatomic, retain) UIScrollView *changescrollView; //记录上一次的scrollView
@property (nonatomic, retain) NSMutableSet *recycledPages;
@property (nonatomic, retain) NSMutableSet *visiblePages;
@property (nonatomic, copy) NSString *docid;
@property (nonatomic, copy) NSString *imageTitle;
@property (nonatomic, copy) NSString *url;

@end

@implementation DJPictureDetailViewController

- (NSMutableSet *)recycledPages
{
    if (!_recycledPages) {
        self.recycledPages = [NSMutableSet set];
    }
    return _recycledPages;
}

- (NSMutableSet *)visiblePages
{
    if (!_visiblePages) {
        self.visiblePages = [NSMutableSet set];
    }
    return _visiblePages;
}

- (NSMutableArray *)photosData
{
    if (!_photosData) {
        self.photosData = [NSMutableArray array];
    }
    return _photosData;
}

- (void)loadView {
    self.pictureDetailView = [[DJPictureDetailView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = self.pictureDetailView;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    DDMenuController *menuC  = delegate.menuController;
    [menuC setEnableGesture:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.fd_prefersNavigationBarHidden = YES;
    //读取数据
    [self readDataByURL];
    [_pictureDetailView.btnBack addTarget:self action:@selector(handleBack:) forControlEvents:UIControlEventTouchUpInside];
    [_pictureDetailView.btnComment addTarget:self action:@selector(handleComment:) forControlEvents:UIControlEventTouchUpInside];
    [_pictureDetailView.btnSave addTarget:self action:@selector(handleSave:) forControlEvents:UIControlEventTouchUpInside];
    [_pictureDetailView.btnShare addTarget:self action:@selector(handleShare:) forControlEvents:UIControlEventTouchUpInside];
    //添加手势
    [self addGestureRecognizer];
}

#pragma mark - UIScrollViewDelegate
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice]userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

//返回缩放的视图
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return  [[scrollView subviews] firstObject];
}
//结束缩放时让imageView 居中
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?(scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?(scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    ((UIImageView *)[[scrollView subviews] firstObject]).center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,scrollView.contentSize.height * 0.5 + offsetY);
}

//最后设置一下 scrollView 的代理方法:
//视图滑动时

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self tilePages];
}
//当滚动视图停⽌
- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView {
    NSInteger index = self.pictureDetailView.imagesScrollView.contentOffset.x / kScreenWidth;
    _pictureDetailView.note.text = [NSString stringWithFormat:@"       %@",self.photosData[index][@"note"]];
    _pictureDetailView.lblPage.text = [NSString stringWithFormat:@"%ld/%ld", (long)(index + 1), (unsigned long)self.photosData.count];
    //切换图片后，将变化的图片，变回原来的大小
    if (_pindex != index) {
        self.changescrollView.zoomScale = 1.0;
    }
    self.changescrollView = [_pictureDetailView.imagesScrollView subviews][0];
    _pindex = index;
}

#pragma mark -  数据类method
- (void)readDataByURL {
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        if (self.Furl)
        {
            [DJNetWork JSONDataWithURL:self.Furl success:^(id data) {
                
                DJPictureDetailModel *model = [[DJPictureDetailModel alloc] init];
                [model setValuesForKeysWithDictionary:data];
                self.pictureDetailView.model = model;
                self.docid = model.postid;
                self.imageTitle = model.setname;
                self.url = model.url;
                [self configureImageScrollView:[NSMutableArray arrayWithArray:model.photos]];
                
            } fail:^{
                
                
            }];
        }
        else
        {
            self.skipTypeID = self.skipTypeID == nil ? @"0096" : [self.skipTypeID substringFromIndex:4];

            [DJNetWork JSONDataWithURL:[NSString stringWithFormat:kURL_ImagesSet,self.skipTypeID,self.skipID] success:^(id data) {
                
                DJPictureDetailModel *model = [[DJPictureDetailModel alloc] init];
                [model setValuesForKeysWithDictionary:data];
                self.pictureDetailView.model = model;
                self.docid = model.postid;
                self.imageTitle = model.setname;
                self.url = model.url;
                [self configureImageScrollView:[NSMutableArray arrayWithArray:model.photos]];
                
            } fail:^{
                
                
            }];

        }
        
    });

}

#pragma mark - 视图布局
- (void)configureImageScrollView:(NSMutableArray *)photos
{
    self.photosData = photos;
    _pictureDetailView.imagesScrollView.contentSize = CGSizeMake(photos.count * kScreenWidth, 0);
    _pictureDetailView.imagesScrollView.delegate = self;
    _pictureDetailView.imagesScrollView.pagingEnabled = YES;
    [self tilePages];
}

#pragma mark - UIScrollView重用机制
- (void)tilePages
{
    CGRect visibleBounds = _pictureDetailView.imagesScrollView.bounds;
    int firstNeededPageIndex = floorf(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds));
    int lastNeededPageIndex = floorf((CGRectGetMaxX(visibleBounds)-1) / CGRectGetWidth(visibleBounds));
    firstNeededPageIndex = MAX(firstNeededPageIndex, 0);
    lastNeededPageIndex = MIN(lastNeededPageIndex, (int)[self.photosData count] - 1);
    if (self.visiblePages) {
        
        for (DJIndexScrollView *page in self.visiblePages) {
            //不显⽰的判断条件
            if (page.index < firstNeededPageIndex || page.index > lastNeededPageIndex) {
                //将没有显示的ImageView保存在recycledPages里
                [self.recycledPages addObject:page];
                //将未显示的ImageView移除
                [page removeFromSuperview];
            }
        }
    }
    //集合-指定集合(即:所有不在既定集合中的元素)
    [self.visiblePages minusSet:self.recycledPages];
    
    while (self.recycledPages.count > 2) {
        [self.recycledPages removeObject:[self.recycledPages anyObject]];
    }
    // add missing pages
    for (int index = firstNeededPageIndex; index <= lastNeededPageIndex; index++)
    {
        if (![self isDisplayingPageForIndex:index])
        { //当index对应的ImageView没有显示时,使用重用来定义ImageView
            DJIndexScrollView *page = [self dequeueRecycledPage]; //当page = = nil
            if (!page) {
                page = [[DJIndexScrollView alloc] init];
                page.bounces = YES;
                page.delegate = self;
                page.zoomScale = 1.0;
                page.minimumZoomScale = 1.0;
                page.maximumZoomScale = 2.0;
                page.showsVerticalScrollIndicator = NO;
                page.directionalLockEnabled = YES;
            }
            //设置index对应的ImageView图片和位置
            [self configurePage:page forIndex:index];
            //将page加入到visiblePages集合里
            [self.visiblePages addObject:page];
            [_pictureDetailView.imagesScrollView addSubview:page];
        }
    }
}

- (BOOL)isDisplayingPageForIndex:(NSUInteger)index
{
    BOOL foundPage = NO;
    for (DJIndexScrollView *page in self.visiblePages) {
        if (page.index == index)
        {
            //如果index所对应的ImageView在可见数组中,将标志位标记为YES,否则返 回NO
            foundPage = YES;
            break;
        }
    }
    return foundPage;
}

- (DJIndexScrollView *)dequeueRecycledPage
{
    //查看是否有重用对象
    DJIndexScrollView *page = [self.recycledPages anyObject];
    if (page)
    {
        //返回重用对象,并从重用集合中删除
        [self.recycledPages removeObject:page];
    }
    return page;
}

- (void)configurePage:(DJIndexScrollView *)page forIndex:(NSUInteger)index {
    page.index = index; //这句要写，不然第一张会消失
    page.frame = CGRectMake(kScreenWidth * index, -20, kScreenWidth, kScreenHeight);
    page.imageV.contentMode = UIViewContentModeScaleAspectFit;//自适应图片大小
    page.imageV.frame = self.view.bounds;
    [page.imageV sd_setImageWithURL:self.photosData[index][@"imgurl"] placeholderImage:[UIImage imageNamed:@"博文新闻3"]];
    
}

#pragma mark - 为滚动视图添加手势
- (void)addGestureRecognizer
{
    //单击手势，隐藏/显示内容
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [_pictureDetailView.imagesScrollView addGestureRecognizer:tap];
    
    //双击手势，进入图片缩放界面
    UITapGestureRecognizer *twoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTwoTap:)];
    twoTap.numberOfTapsRequired = 2;
    [_pictureDetailView.imagesScrollView addGestureRecognizer:twoTap];

    //解决单击双击手势并存问题
    [tap requireGestureRecognizerToFail:twoTap];
    
    //长按手势 ，用户保存图片到相册
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlePress:)];
    [_pictureDetailView.imagesScrollView addGestureRecognizer:press];

}

#pragma mark - action
//pop
- (void)handleBack:(UIButton *)sender {
    self.tabBarController.tabBar.hidden = NO; //将tabBar显示出来
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:20], NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self.navigationController popViewControllerAnimated:YES];
}

//push到评论
- (void)handleComment:(UIButton *)sender
{
    
    DJCommentViewController *commentController = [[DJCommentViewController alloc] init];
    commentController.docid = self.docid; //传唯一标识
    commentController.flag = @"photoview_bbs"; //标识是图片集, 跳转评论标识
    
    [self setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:commentController animated:YES];
    [self setHidesBottomBarWhenPushed:YES];
}
//收藏
- (void)handleSave:(UIButton *)sender
{
    [[DJData shareData] openDataBase];
    FavoriteModel *fmodel = [[FavoriteModel alloc] init];
    fmodel.ftitle = self.imageTitle;
    fmodel.furl = [NSString stringWithFormat:kURL_ImagesSet,self.skipTypeID, self.skipID];
    fmodel.fdocid = self.skipID;
    fmodel.fboardid = @"photoview_bbs";
    fmodel.flag = @"PICTURES";
    MBProgressHUD *hud= [[MBProgressHUD alloc] init];
    [self.view addSubview:hud];
    if ([[DJData shareData] insertData:fmodel]) {
        //加载条上显示文本
        hud.labelText = @"收藏成功";
    } else {
        hud.labelText = [fmodel.ftitle isEqualToString:@""] || !fmodel.ftitle ? @"加载完成才能收藏哦？" : @"已经收藏";
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

//手势处理action
- (void)handleTap:(UIGestureRecognizer *)tap {
    if (_pictureDetailView.layerView.frame.origin.y < 0)
    {
        [UIView animateWithDuration:0.5 animations:^{
            self.fd_prefersNavigationBarHidden = NO;

            _pictureDetailView.toolBar.frame = CGRectMake(0, self.view.frame.size.height - 40, kScreenWidth, 40);
            _pictureDetailView.layerView.frame = CGRectMake(0, 0, kScreenWidth, 100);
            _pictureDetailView.layerViewNote.frame = CGRectMake(0, self.view.frame.size.height - 170, kScreenWidth, 170);
        }];
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            self.fd_prefersNavigationBarHidden = YES;
            
            _pictureDetailView.toolBar.frame = CGRectMake(0, self.view.frame.size.height + 40, kScreenWidth, 40);
            _pictureDetailView.layerView.frame = CGRectMake(10, - 100 , kScreenWidth, 100);
            _pictureDetailView.layerViewNote.frame = CGRectMake(0, self.view.frame.size.height + 170, kScreenWidth, 170);
        }];
    }
}
//双击缩放
- (void)handleTwoTap:(UITapGestureRecognizer *)pinch {
    self.modalTransitionStyle =  UIModalTransitionStyleFlipHorizontal;
    _pindex = _pictureDetailView.imagesScrollView.contentOffset.x / kScreenWidth;
    if (_pictureDetailView.imagesScrollView.subviews.count) {
        self.changescrollView = [_pictureDetailView.imagesScrollView subviews][0];
        [UIView animateWithDuration:0.5 animations:^{
            self.changescrollView .zoomScale =  self.changescrollView.zoomScale == 1.0 ? 2.0 : 1.0;
        }];
    }
}
- (void)handlePress:(UIGestureRecognizer *)press {
    //保存imageView上展示的图片到相册
    if (press.state == UIGestureRecognizerStateBegan) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定要保存吗？" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *act1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            if (_pictureDetailView.imagesScrollView.subviews.count)
            {
                
                UIScrollView *tempScroll = [_pictureDetailView.imagesScrollView subviews][0];
                UIImageView *imageV = [[tempScroll subviews] firstObject];
                UIImageWriteToSavedPhotosAlbum(imageV.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            } else {
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"没有可保存的图片" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *act1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                    
                }];
                [alert addAction:act1];
                
                [self presentViewController:alert animated:YES completion:nil];
            }
            
        }];
        [alert addAction:act1];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }
}


//判断图片保存状态
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error == nil) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"保存成功" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *act1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            
        }];
        [alert addAction:act1];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)handleShare:(UIButton *)button
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (id key in self.photosData)
    {
        [array addObject:key[@"timgurl"]];
        
    }
    
        //1、构造分享内容
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params SSDKSetupShareParamsByText:self.pictureDetailView.note.text
                                images:array
                                   url:[NSURL URLWithString:[NSString stringWithFormat:kURL_ImagesSet,self.skipTypeID,self.skipID]]
                                 title:self.pictureDetailView.lblTitle.text
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
