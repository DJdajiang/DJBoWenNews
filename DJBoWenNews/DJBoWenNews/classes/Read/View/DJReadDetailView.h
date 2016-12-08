//
//  DJReadDetailView.h
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/14.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJReadDetailModel.h"
#import "PrefixHeader.pch"

@interface DJReadDetailView : UIView

@property (nonatomic, retain) UILabel *title;
@property (nonatomic, retain) UILabel *source; //来源
@property (nonatomic, retain) UILabel *date;
@property (nonatomic, retain) UIWebView *webView;

@property (nonatomic, retain) UIView *toolBar;//工具栏
@property (nonatomic, retain) UIButton *btnShare; //分享按钮
@property (nonatomic, retain) UIButton *btnSave;  //收藏
@property (nonatomic, retain) UIButton *btnComment; //评论按钮

@property (nonatomic, retain) DJReadDetailModel *model;

@end
