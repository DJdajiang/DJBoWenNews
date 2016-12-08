//
//  AppDelegate.m
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/7.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import "AppDelegate.h"
#import "MyTabBarViewController.h"
#import "DJMineController.h"
#import <ShareSDK/ShareSDK.h>
@interface AppDelegate ()

@end

@implementation AppDelegate
- (DDMenuController *)menuController
{
    if (!_menuController) {
        self.menuController = [[DDMenuController alloc] init];
    }
    return _menuController;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    sleep(3);
    
    MyTabBarViewController *myTab = [[MyTabBarViewController alloc] init];
    DJMineController *mine = [[DJMineController alloc] init];
    NSLog(@"哈哈");
    self.menuController.rootViewController = myTab;
    self.menuController.leftViewController = mine;
    self.window.rootViewController = self.menuController;
    
    //判断网络
    [self judgeNetworking];
    [self shareSDK];
    return YES;
}

- (void)shareSDK
{
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册，
     *  在将生成的AppKey传入到此方法中。我们Demo提供的appKey为内部测试使用，可能会修改配置信息，请不要使用。
     *  方法中的第二个参数用于指定要使用哪些社交平台，以数组形式传入。第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    [ShareSDK registerApp:@"iosv1101"
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ),
                            @(SSDKPlatformTypeRenren)]
                 onImport:^(SSDKPlatformType platformType) {
                     
                     switch (platformType)
                     {
                         case SSDKPlatformTypeWechat:
                             //                             [ShareSDKConnector connectWeChat:[WXApi class]];
                             [ShareSDKConnector connectWeChat:[WXApi class] delegate:self];
                             break;
                         case SSDKPlatformTypeQQ:
                             [ShareSDKConnector connectQQ:[QQApiInterface class]
                                        tencentOAuthClass:[TencentOAuth class]];
                             break;
                         case SSDKPlatformTypeSinaWeibo:
                             [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                             break;
                         case SSDKPlatformTypeRenren:
                             [ShareSDKConnector connectRenren:[RennClient class]];
                             break;
                         
                         default:
                             break;
                     }
                 }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
              
              switch (platformType)
              {
                  case SSDKPlatformTypeSinaWeibo:
                      //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                      [appInfo SSDKSetupSinaWeiboByAppKey:@"3954192171"
                                                appSecret:@"9fe966188daf243b5f1cbc3e7985f40d"
                                              redirectUri:@"http://www.sharesdk.cn"
                                                 authType:SSDKAuthTypeBoth];
                      break;
                  case SSDKPlatformTypeWechat:
                      [appInfo SSDKSetupWeChatByAppId:@"wxba15041b9306f276"
                                            appSecret:@"2aaec81ca2d04e6bf86b56ddb0ad2021"];
                      break;
                  case SSDKPlatformTypeQQ:
                      [appInfo SSDKSetupQQByAppId:@"1105696937"
                                           appKey:@"ZthEyZFPIhd6M3DH"
                                         authType:SSDKAuthTypeBoth];
                      break;
                  case SSDKPlatformTypeRenren:
                      [appInfo SSDKSetupRenRenByAppId:@"226427"
                                               appKey:@"fc5b8aed373c4c27a05b712acba0f8c3"
                                            secretKey:@"f29df781abdd4f49beca5a2194676ca4"
                                             authType:SSDKAuthTypeBoth];
                      break;
                  default:
                      break;
              }
          }];

}

- (void)judgeNetworking
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
    {
        
        if (AFNetworkReachabilityStatusNotReachable == status)
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"网络你别走" message:@"木牛网络是多么痛的领悟!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *act1 = [UIAlertAction actionWithTitle:@"拜拜" style:UIAlertActionStyleCancel handler:nil];
            
            [alert addAction:act1];
            
            [self.menuController presentViewController:alert animated:YES completion:nil];
        }
        
    }];
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
