//
//  DJPictureDetailView.h
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/12.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJPictureDetailModel.h"
#import "PrefixHeader.pch"

@interface DJPictureDetailView : UIView

@property (nonatomic, retain) UILabel *lblTitle;         //显示标题
@property (nonatomic, retain) UIScrollView *imagesScrollView; //图片滚动视图
@property (nonatomic, retain) UITextView *note;//图片简介

@property (nonatomic, retain) UIView *toolBar;//工具栏
@property (nonatomic, retain) UILabel *lblPage; //当前页
@property (nonatomic, retain) UIButton *btnShare; //分享按钮
@property (nonatomic, retain) UIButton *btnComment;  //评论
@property (nonatomic, retain) UIButton *btnSave;  //收藏
@property (nonatomic, retain) UIButton *btnBack;  //返回

//渐变层，用与显示背景渐变的标题，和内容
@property (nonatomic, retain) UIView *layerView, *layerViewNote;

@property (nonatomic, retain) DJPictureDetailModel *model;

@end
