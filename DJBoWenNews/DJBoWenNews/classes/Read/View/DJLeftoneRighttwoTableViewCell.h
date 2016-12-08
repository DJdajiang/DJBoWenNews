//
//  DJLeftoneRighttwoTableViewCell.h
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/15.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJReadModel.h"
#import "PrefixHeader.pch"

@interface DJLeftoneRighttwoTableViewCell : UITableViewCell

@property (nonatomic, retain) UIImageView *leftImage; //左单一的一个图
@property (nonatomic, retain) UILabel *titleLabel;  //标题
@property (nonatomic, retain) UILabel *digestLabel; //简介
@property (nonatomic, retain) UILabel *sourceLabel;  //左下角来源
@property (nonatomic, retain) UILabel *replyCountLabel;  //跟帖Label
@property (nonatomic, retain) UIImageView *rightImageUp;  //右上图片
@property (nonatomic, retain) UIImageView *rightImageDown;  //右下图片

//赋值
- (void)configureCellWithRead:(DJReadModel *)readModel;

+ (CGFloat)heightForRowWithReadNews:(DJReadModel *)readNews;

@end
