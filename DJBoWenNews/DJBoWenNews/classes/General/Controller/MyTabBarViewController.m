//
//  MyTabBarViewController.m
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/7.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import "MyTabBarViewController.h"
#import "DJNewsViewController.h"
#import "DJReadViewController.h"
#import "DJPictureViewController.h"
#import "DJVideoController.h"

@interface MyTabBarViewController ()

@end

@implementation MyTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //设置所有导航条的颜色
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:35 / 255.0 green:141 / 255.0 blue:255 / 255.0 alpha:1.0]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    //设置所有标签栏的颜色
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    //设置导航条字体样式
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:20]}];
    
    [self configureTapBarItem];
}

- (void)configureTapBarItem
{
    DJNewsViewController *new = [[DJNewsViewController alloc] init];
    
    new.title = @"博文";
    
    DJReadViewController *read = [[DJReadViewController alloc] init];
    read.title = @"随读";
    
    DJPictureViewController *picture = [[DJPictureViewController alloc] init];
    picture.title = @"流图";
    
    DJVideoController *video = [[DJVideoController alloc] init];
    video.title = @"微视";
    
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:new];
    
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:read];
    
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:picture];
    
    UINavigationController *nav4 = [[UINavigationController alloc] initWithRootViewController:video];
    
    nav1.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"博文" image:[UIImage imageNamed:@"tabbar_icon_news_normal"] tag:0];
    
    nav2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"随读" image:[UIImage imageNamed:@"tabbar_icon_reader_normal"] tag:0];
    
    nav3.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"流图" image:[UIImage imageNamed:@"cell_tag_photo"] tag:0];
    
    nav4.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"微视" image:[UIImage imageNamed:@"tabbar_icon_media_normal"] tag:0];
    
    self.viewControllers = @[nav1,nav2,nav3,nav4];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
