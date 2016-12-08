//
//  DJReadDatailViewController.h
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/14.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DJReadDatailViewController : UIViewController


/**
 *  阅读详细界面视图控制器
 */
@property (nonatomic, copy) NSString *docid;   //唯一标识
@property (nonatomic, copy) NSString *newsTitle;
@property (nonatomic, copy) NSString *newsDegst;
@property (nonatomic, copy) NSString *flag; //标记是从阅读push，还是新闻push，为转到评论做唯一标识
@property (nonatomic, copy) NSString *url_3w;
@property (nonatomic, strong) NSArray *imageArray;

@end
