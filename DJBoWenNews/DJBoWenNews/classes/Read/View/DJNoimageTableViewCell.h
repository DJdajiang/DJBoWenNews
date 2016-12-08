//
//  DJNoimageTableViewCell.h
//  BoWenNew
//
//  Created by 刘文江 on 2016/10/15.
//  Copyright © 2016年 刘文江. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJReadModel.h"
#import "PrefixHeader.pch"

@interface DJNoimageTableViewCell : UITableViewCell

@property (nonatomic, retain) UILabel *titleLabel;  //主题
@property (nonatomic, retain) UILabel *digestLabel;  //简介
@property (nonatomic, retain) UILabel *sourceLabel;  //文章来源
@property (nonatomic, retain) UILabel *replyCountLabel;  //分享按钮

//赋值,让readListModel对象中存储一条阅读信息
- (void)configureCellWithRead:(DJReadModel *)readNews;

+ (CGFloat)heightForRowWithReadNews:(DJReadModel *)readNews;
@end
