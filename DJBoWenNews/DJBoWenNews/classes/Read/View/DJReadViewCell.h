//
//  DJReadViewCell.h
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/14.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJReadModel.h"
#import "PrefixHeader.pch"

@interface DJReadViewCell : UITableViewCell

@property (nonatomic,retain) UIImageView *photoView; //左边的图片
@property (nonatomic,retain) UILabel *titleLabel;  //标题
@property (nonatomic,retain) UILabel *digestLabel; //简介
@property (nonatomic,retain) UILabel *sourceLabel;  //来源
@property (nonatomic,retain) UILabel *replyCountLabel;  //跟帖数量

//赋值,让DJReadModel对象中存储一条阅读信息
- (void)configureCellWithRead:(DJReadModel *)readNews;

//自适应cell
+ (CGFloat)heightForRowWithReadNews:(DJReadModel *)readNews;

@end
